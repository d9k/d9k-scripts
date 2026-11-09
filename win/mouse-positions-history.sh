#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ARGS_COMMAND="$1"

source "$SCRIPT_DIR/displays.inc.sh"

DISPLAY_NUM="$(get_mouse_display_num)"
MOUSE_POS_LOG_PATH="$HOME/.mouse-pos-history-display${DISPLAY_NUM}.json.log"
MAX_HISTORY_STEPS=5
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
