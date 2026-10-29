#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

# $SCRIPT_DIR/mouse-switch-display.sh
# $SCRIPT_DIR/mouse-warp-point.sh
notify-send -t 5000 "Choose end of selection with warpd"


# xte slightly faster than xdotool
# `sudo apt install xautomation` required for xte!
xte 'keyup Super_L'
xte 'keyup Shift_L'
$SCRIPT_DIR/mouse-hold-left-button.sh

# warpd --screen --hint2 --oneshot

$SCRIPT_DIR/warpd-cfg-set-hint-color.sh "#00E5FF"
$SCRIPT_DIR/mouse-move-from-warpd-daemon.sh

EXIT_CODE=$?
$SCRIPT_DIR/mouse-release-left-button.sh
