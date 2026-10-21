#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

xdotool keyup Super
xdotool click 1
sleep 0.05
xdotool click 1

$SCRIPT_DIR/mouse-events-count-reset.sh
