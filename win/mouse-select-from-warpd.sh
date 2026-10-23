#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

# $SCRIPT_DIR/mouse-switch-display.sh
# $SCRIPT_DIR/mouse-warp-point.sh
notify-send -t 5000 "Choose end of selection with warpd"

$SCRIPT_DIR/mouse-hold-left-button.sh

warpd --screen --hint2 --oneshot

$SCRIPT_DIR/mouse-release-left-button.sh
