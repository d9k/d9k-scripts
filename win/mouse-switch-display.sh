#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOUSE_X=$($SCRIPT_DIR/get-mouse-x.sh)
echo $MOUSE_X

if [ $MOUSE_X -le 2560 ]; then
  xdotool mousemove 3100 844
else
  xdotool mousemove 1280 780
fi
