#!/bin/bash

# Use `wmctrl -lx` to see opened windows classes
WINDOW_CLASS="Shutter"
COMMAND="/usr/bin/shutter"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
