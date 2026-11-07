#!/bin/bash

MOUSE_POS_LOG_PATH="$HOME/.mouse-pos-history.json.log"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
POPPED_RECORD_WAS_FOUND=
NOTIFY_TIMEOUT_MS=3000
BORDER_DARK_RED_COLOR="0x502020"
BORDER_SHOW_MS=500

function echoerr {
  printf "%s\n" "$*" >&2;
}

# "[[ -s FILE ]]" is true when the file exists and is not empty (size greater than zero)
while [[ -s "$MOUSE_POS_LOG_PATH" ]]; do
  LAST_RECORD="$("$SCRIPT_DIR/mouse-positions-history-last.sh")"

  SAVED_X="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.x')"
  SAVED_Y="$(printf "%s" "$LAST_RECORD" | jq --raw-output '.y')"

  eval "$(xdotool getmouselocation --shell)"
  CURRENT_X="$X"
  CURRENT_Y="$Y"

  # sed '$d' deletes the last line: "$" is the address of the last line, "d" is the delete command;
  sed --in-place '$d' "$MOUSE_POS_LOG_PATH"

  if [[ "$SAVED_X" != "$CURRENT_X" || "$SAVED_Y" != "$CURRENT_Y" ]]; then
    xdotool mousemove "$SAVED_X" "$SAVED_Y"
    POPPED_RECORD_WAS_FOUND=1
    break
  fi
done

if [[ -z "$POPPED_RECORD_WAS_FOUND" ]]; then
  echoerr "Error: history is empty"

  BORDER_COLOR="$BORDER_DARK_RED_COLOR" BORDER_TIMEOUT_MS="$BORDER_SHOW_MS" "$SCRIPT_DIR/border-window-current-display.sh" &

  notify-send --expire-time "$NOTIFY_TIMEOUT_MS" "Mouse position history is empty"

  exit 100
fi
