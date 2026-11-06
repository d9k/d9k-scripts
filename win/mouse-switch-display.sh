#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOUSE_X=$($SCRIPT_DIR/get-mouse-x.sh)
echo $MOUSE_X

DISPLAY1_X=0
DISPLAY1_Y=144
DISPLAY1_W=2560
DISPLAY1_H=1440
DISPLAY2_X=$((DISPLAY1_X + DISPLAY1_W))
DISPLAY2_Y=0
DISPLAY2_W=1080
DISPLAY2_H=1920

DISPLAY1_X2=$(($DISPLAY1_X + $DISPLAY1_W))
DISPLAY1_Y2=$(($DISPLAY1_Y + $DISPLAY1_H))

DISPLAY2_X2=$(($DISPLAY2_X + $DISPLAY2_W))
DISPLAY2_Y2=$(($DISPLAY2_Y + $DISPLAY2_H))

DISPLAY1_MX=$(( ($DISPLAY1_X + $DISPLAY1_X2) / 2))
DISPLAY1_MY=$(( ($DISPLAY1_Y + $DISPLAY1_Y2) / 2))

DISPLAY2_MX=$(( ($DISPLAY2_X + $DISPLAY2_X2) / 2))
DISPLAY2_MY=$(( ($DISPLAY2_Y + $DISPLAY2_Y2) / 2))

BORDER_COLOR="0x0004000"
BORDER_WIDTH="8"
BORDER_TIMEOUT_MS=700

echo $DISPLAY1_MX $DISPLAY1_MY $DISPLAY2_MX $DISPLAY2_MY 

function show_border_window_coords {
  # set -x
  # killall border-window.py
  pkill -f "border-window.py"

  $SCRIPT_DIR/border-window.py \
    $BORDER_COLOR \
    --border-width $BORDER_WIDTH \
    --timeout $BORDER_TIMEOUT_MS \
    "$@"
}

if [ $MOUSE_X -le $DISPLAY2_X ]; then
  xdotool mousemove $DISPLAY2_MX $DISPLAY2_MY

  show_border_window_coords \
    $DISPLAY2_X $DISPLAY2_Y \
    $DISPLAY2_X2 $DISPLAY2_Y2

  # xdotool mousemove 3100 844
else
  # xdotool mousemove 1280 780
  xdotool mousemove $DISPLAY1_MX $DISPLAY1_MY

  show_border_window_coords \
    $DISPLAY1_X $DISPLAY1_Y \
    $DISPLAY1_X2 $DISPLAY1_Y2 
fi
