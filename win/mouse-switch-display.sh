#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOUSE_X=$($SCRIPT_DIR/get-mouse-x.sh)
echo $MOUSE_X

source "$SCRIPT_DIR/displays.inc.sh"

BORDER_COLOR="0x0004000"
BORDER_WIDTH="8"
BORDER_TIMEOUT_MS=700

if [ $MOUSE_X -le $DISPLAY2_X ]; then
  xdotool mousemove $DISPLAY2_MX $DISPLAY2_MY
else
  xdotool mousemove $DISPLAY1_MX $DISPLAY1_MY
fi


$SCRIPT_DIR/border-window-current-display.sh
