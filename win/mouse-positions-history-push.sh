#!/bin/bash

MOUSE_POS_LOG_PATH="$HOME/.mouse-pos-history.json.log"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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
