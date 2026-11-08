#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/displays.inc.sh"

if [ -z "$BORDER_COLOR" ]; then
  BORDER_COLOR="0x0004000"
fi

if [[ -z "$BORDER_WIDTH" ]]; then
  BORDER_WIDTH="8"
fi

if [[ -z "$BORDER_TIMEOUT_MS" ]]; then
  BORDER_TIMEOUT_MS=700
fi

function show_border_window_coords {
  pkill -f "border-window.py"

  $SCRIPT_DIR/border-window.py \
    $BORDER_COLOR \
    --border-width $BORDER_WIDTH \
    --timeout $BORDER_TIMEOUT_MS \
    "$@"
}

MOUSE_DISPLAY_NUM="$(get_mouse_display_num)"

case "$MOUSE_DISPLAY_NUM" in
  1)
    show_border_window_coords \
      $DISPLAY1_X $DISPLAY1_Y \
      $DISPLAY1_X2 $DISPLAY1_Y2
    ;;
  2)
    show_border_window_coords \
      $DISPLAY2_X $DISPLAY2_Y \
      $DISPLAY2_X2 $DISPLAY2_Y2
    ;;
esac
