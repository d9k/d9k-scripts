#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

$SCRIPT_DIR/warpd-cfg-set-hint-color.sh
$SCRIPT_DIR/mouse-move-from-warpd-daemon.sh
EXIT_CODE=$?
echo $EXIT_CODE

if [ $EXIT_CODE == 100 ]; then
  # xte slightly faster than xdotool
  # `sudo apt install xautomation` required for xte!
  xte 'keyup Super_L'
  # xte 'keyup Shift_L'
  sleep 0.1
  # $SCRIPT_DIR/mouse-click-left.sh
      xdotool click --clearmodifiers 1
fi
