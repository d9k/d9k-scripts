#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOUSE_POS_LOG_PATH="$HOME/.mouse-pos-history.json.log"
MAX_HISTORY_STEPS=6

eval "$(xdotool getmouselocation --shell)"
CURRENT_X="$X"
CURRENT_Y="$Y"
UNIX_TIMESTAMP="$(date +%s)"

LAST_RECORD="$("$SCRIPT_DIR/mouse-positions-history-last.sh")"

if [[ -n "$LAST_RECORD" ]]; then
  LAST_X="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.x')"
  LAST_Y="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.y')"

  if [[ "$LAST_X" == "$CURRENT_X" && "$LAST_Y" == "$CURRENT_Y" ]]; then
    exit 0
  fi
fi

jq --compact-output --null-input \
  --argjson x "$CURRENT_X" \
  --argjson y "$CURRENT_Y" \
  --argjson unix_timestamp "$UNIX_TIMESTAMP" \
  '{x: $x, y: $y, unix_timestamp: $unix_timestamp}' >> "$MOUSE_POS_LOG_PATH"

LINE_COUNT="$(wc --lines < "$MOUSE_POS_LOG_PATH")"
EXCESS_LINES=$((LINE_COUNT - MAX_HISTORY_STEPS))

if [ $EXCESS_LINES -gt 0 ]; then
  # "1,${EXCESS_LINES}d" deletes the oldest lines at the top of the log
  sed --in-place "1,${EXCESS_LINES}d" "$MOUSE_POS_LOG_PATH"
fi
