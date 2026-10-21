#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

# $SCRIPT_DIR/mouse-switch-display.sh
# $SCRIPT_DIR/mouse-warp-point.sh

warpd --screen --hint --oneshot

$SCRIPT_DIR/mouse-click-right.sh
