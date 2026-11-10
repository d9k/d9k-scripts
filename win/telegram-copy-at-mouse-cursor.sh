#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

$SCRIPT_DIR/mouse-click-right.sh

sleep 0.5
# xdotool sleep 0.05 key Down
# xdotool sleep 0.05 key Down
# xdotool sleep 0.05 key Down
# xdotool sleep 0.05 key Down
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
# xdotool sleep 0.05 key Up
sleep 0.1
xdotool sleep 0.05 key Return
