#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/displays.inc.sh"

MOUSE_DISPLAY_NUM="$(get_mouse_display_num)"

BORDER_COLOR="0x0005010"
BORDER_WIDTH="8"
BORDER_TIMEOUT_MS=700

case "$MOUSE_DISPLAY_NUM" in
  1)
    xdotool mousemove $DISPLAY2_MX $DISPLAY2_MY
    ;;
  2)
    xdotool mousemove $DISPLAY1_MX $DISPLAY1_MY
    ;;
esac


$SCRIPT_DIR/overlay-window-border-current-display.sh
