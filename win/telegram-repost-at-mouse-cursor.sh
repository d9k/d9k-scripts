#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

sleep 0.2
$SCRIPT_DIR/mouse-click-right.sh

sleep 0.5
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Return
sleep 1
xdotool sleep 0.05 type '/'
