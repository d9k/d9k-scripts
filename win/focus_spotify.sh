#!/bin/bash

# wmctrl -lx
WINDOW_CLASS="Spotify"
COMMAND="spotify &"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "$SCRIPT_DIR"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
