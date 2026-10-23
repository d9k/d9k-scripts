#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xdotool keyup Super

xte 'keyup Super_L'

#sleep 0.1
# xdotool click 2

# xte slightly faster than xdotool
# `sudo apt install xautomation` required for xte!
xte "mouseclick 2"

$SCRIPT_DIR/mouse-events-count-reset.sh

