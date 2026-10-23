#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MOUSE_SPEED_PX=$($SCRIPT_DIR/get-mouse-step-speed-px.sh)
MOUSE_EVENTS_COUNT_INC_TIMEOUT_S=1
if [ -z "$MOUSE_SPEED_PX" ]; then
  MOUSE_SPEED_PX=30
fi

MOUSE_EVENT_COUNT_OVERFLOW=$($SCRIPT_DIR/get-mouse-events-count-overflow.sh)
if [[ "$MOUSE_EVENT_COUNT_OVERFLOW" != 0 ]]; then
  echo "Error: Mouse event count overflow"
  exit
fi

MOUSE_EVENT_COUNT=$($SCRIPT_DIR/mouse-events-count-inc.sh)

echo "$MOUSE_EVENT_COUNT"

# xdotool mousemove_relative -- 0 $MOUSE_SPEED_PX

# xte slightly faster than xdotool
# `sudo apt install xautomation` required for xte!
xte "mousermove 0 $MOUSE_SPEED_PX"

sleep "$MOUSE_EVENTS_COUNT_INC_TIMEOUT_S"
NEW_MOUSE_EVENTS_COUNT=$($SCRIPT_DIR/mouse-events-count-dec.sh)
