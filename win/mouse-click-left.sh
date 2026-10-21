#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

xdotool keyup Super
#sleep 0.1
xdotool click 1

$SCRIPT_DIR/mouse-events-count-reset.sh
