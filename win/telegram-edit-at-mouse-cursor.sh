#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

$SCRIPT_DIR/mouse-click-right.sh

xdotool sleep 0.05 key Down
xdotool sleep 0.05 key Down
xdotool sleep 0.05 key Return
