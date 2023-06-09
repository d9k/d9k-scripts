#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# TODO
xdotool sleep 0.2 key --clearmodifiers "Control_L+c"

${SCRIPT_DIR}/focus_terminal.sh

xdotool sleep 0.2 key --clearmodifiers "Control_L+Shift+v"
xdotool sleep 0.2 key --clearmodifiers "Return"


