#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ARGS_COMMAND="$1"

source "$SCRIPT_DIR/displays.inc.sh"

DISPLAY_NUM="$(get_mouse_display_num)"
MOUSE_POS_LOG_PATH="$HOME/.mouse-pos-history-display${DISPLAY_NUM}.json.log"
MAX_HISTORY_STEPS=5
MIN_EXISTING_DOT_DISTANCE=16
NOTIFY_TIMEOUT_MS=3000
BORDER_DARK_RED_COLOR="0x502020"
BORDER_SHOW_MS=500
DOTS_SHOW_MS=3000
DOTS_GREEN_COLOR="0x00FF00"
DOTS_OUTLINE_COLOR="0x000000"
DOTS_OUTLINE_WIDTH=2
POPPED_RECORD_WAS_FOUND=

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME push|pop"
  exit $EXIT_CODE
}

function get_last_record {
  # "[[ -s FILE ]]" is true when the file exists and is not empty (size greater than zero)
  if [[ ! -s "$MOUSE_POS_LOG_PATH" ]]; then
    return
  fi

  tail --lines 1 "$MOUSE_POS_LOG_PATH"
}

function set_current_mouse_position {
  eval "$(xdotool getmouselocation --shell)"
  CURRENT_X="$X"
  CURRENT_Y="$Y"
}

function push_history {
  set_current_mouse_position
  UNIX_TIMESTAMP="$(date +%s)"

  LAST_RECORD="$(get_last_record)"

  if [[ -n "$LAST_RECORD" ]]; then
    LAST_X="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.x')"
    LAST_Y="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.y')"

    if [[ "$LAST_X" == "$CURRENT_X" && "$LAST_Y" == "$CURRENT_Y" ]]; then
      return
    fi
  fi

  # scan the whole log from the bottom up to find the record closest to the new point and delete it,
  # so the history keeps only visibly distinct positions;
  # MOST_NARROW_DOT_DISTANCE starts at MIN_EXISTING_DOT_DISTANCE, which is both the initial best value and the
  # deletion threshold, so a record is only ever replaced by a strictly closer one and ties resolve to the lower
  # line, because the lower line is met first
  MOST_NARROW_DOT_DISTANCE=$(($MIN_EXISTING_DOT_DISTANCE + 1))
  MOST_NARROW_DOT_NUMBER=

  if [[ -s "$MOUSE_POS_LOG_PATH" ]]; then
    TOTAL_LINES="$(wc --lines < "$MOUSE_POS_LOG_PATH")"

    for ((LINE=TOTAL_LINES; LINE>=1; LINE--)); do
      OLD_RECORD="$(sed --quiet --expression "${LINE}p" "$MOUSE_POS_LOG_PATH")"
      OLD_X="$(printf "%s" "$OLD_RECORD" | jq --raw-output '.x')"
      OLD_Y="$(printf "%s" "$OLD_RECORD" | jq --raw-output '.y')"

      # gawk does not know the "--begin" option and prints its usage instead, so the program is passed as a standard "BEGIN { ... }" block
      DISTANCE="$(awk "BEGIN { printf \"%d\", sqrt((${CURRENT_X} - ${OLD_X})^2 + (${CURRENT_Y} - ${OLD_Y})^2) }")"

      if [ $DISTANCE -lt $MOST_NARROW_DOT_DISTANCE ]; then
        MOST_NARROW_DOT_DISTANCE="$DISTANCE"
        MOST_NARROW_DOT_NUMBER="$LINE"
      fi
    done
  fi

  if [[ -n "$MOST_NARROW_DOT_NUMBER" ]]; then
    sed --in-place "${MOST_NARROW_DOT_NUMBER}d" "$MOUSE_POS_LOG_PATH"
  fi

  jq --compact-output --null-input \
    --argjson x "$CURRENT_X" \
    --argjson y "$CURRENT_Y" \
    --argjson unix_timestamp "$UNIX_TIMESTAMP" \
    '{x: $x, y: $y, unix_timestamp: $unix_timestamp}' >> "$MOUSE_POS_LOG_PATH"

  LINE_COUNT="$(wc --lines < "$MOUSE_POS_LOG_PATH")"
  EXCESS_LINES=$((LINE_COUNT - MAX_HISTORY_STEPS))

  # "1,Nd" deletes the oldest N lines at the top of the log, so the history never grows past MAX_HISTORY_STEPS records
  if [ $EXCESS_LINES -gt 0 ]; then
    sed --in-place "1,${EXCESS_LINES}d" "$MOUSE_POS_LOG_PATH"
  fi
}

function pop_history {
  MAX_POP_STEPS=0
  if [[ -s "$MOUSE_POS_LOG_PATH" ]]; then
    MAX_POP_STEPS="$(wc --lines < "$MOUSE_POS_LOG_PATH")"
  fi

  set_current_mouse_position

  # sed rotates every deleted last line back to the top of the log, so the file never shrinks;
  # iterate only over the initial line count to not loop forever when all records equal the current mouse position
  for ((POP_STEP=1; POP_STEP<=MAX_POP_STEPS; POP_STEP++)); do
    LAST_RECORD="$(get_last_record)"

    SAVED_X="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.x')"
    SAVED_Y="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.y')"

    # "1i TEXT" inserts TEXT before the first line, "$d" deletes the last line ("$" is the address of the last line, "d" is the delete command);
    # "1i" must be before "$d", because "$d" restarts the sed cycle and skips expressions after it
    sed --in-place \
      --expression "1i $LAST_RECORD" \
      --expression '$d' \
      "$MOUSE_POS_LOG_PATH"

    if [[ "$SAVED_X" != "$CURRENT_X" || "$SAVED_Y" != "$CURRENT_Y" ]]; then
      xdotool mousemove "$SAVED_X" "$SAVED_Y"
      POPPED_RECORD_WAS_FOUND=1
      break
    fi
  done

  if [[ -z "$POPPED_RECORD_WAS_FOUND" ]]; then
    echoerr "Error: history is empty"

    BORDER_COLOR="$BORDER_DARK_RED_COLOR" BORDER_TIMEOUT_MS="$BORDER_SHOW_MS" "$SCRIPT_DIR/overlay-window-border-current-display.sh" &

    notify-send --expire-time "$NOTIFY_TIMEOUT_MS" "Mouse position history is empty"

    exit 100
  fi

  # take the PIDs of the previously shown dots windows BEFORE drawing the new one,
  # and kill them only after the new window is up, so there is no flicker between repeated pop presses
  OLD_WINDOWS_DOTS_PIDS="$(pgrep --full "overlay-window-dots.py")"

  JSON_POINTS="$(jq --compact-output --slurp '.' "$MOUSE_POS_LOG_PATH")"

  "$SCRIPT_DIR/overlay-window-dots.py" "$JSON_POINTS" \
    --color "$DOTS_GREEN_COLOR" \
    --outline-color "$DOTS_OUTLINE_COLOR" \
    --outline-width "$DOTS_OUTLINE_WIDTH" \
    --timeout "$DOTS_SHOW_MS" &

  sleep 0.2
  printf "%s" "$OLD_WINDOWS_DOTS_PIDS" | xargs --no-run-if-empty kill -9
}

case "$ARGS_COMMAND" in
  push)
    push_history
    ;;
  pop)
    pop_history
    ;;
  *)
    help_exit
    ;;
esac
