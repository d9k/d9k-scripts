#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xdotool click 2
xdotool click --clearmodifiers 2

# xdotool mousedown 2 
# sleep 0.1 
# xdotool mouseup 2

$SCRIPT_DIR/mouse-events-count-reset.sh

