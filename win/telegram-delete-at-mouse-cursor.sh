#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

$SCRIPT_DIR/mouse-click-right.sh

xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Return
# sleep 0.1
# xdotool sleep 0.05 key Return
