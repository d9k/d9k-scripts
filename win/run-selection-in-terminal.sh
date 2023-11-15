#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# TODO
xdotool sleep 0.2 key --clearmodifiers "Control_L+c"

${SCRIPT_DIR}/focus_terminal.sh

CLIPBOARD=$(xsel -ob)

# Run code between back quotes only, if present (for markdown) ``
CLIPBOARD_FIXED=$(echo -e "$CLIPBOARD" |  cut -d "\`" -f2)

echo -e "$CLIPBOARD_FIXED" | xclip -selection c

xdotool sleep 1.5 key --clearmodifiers "Control_L+Shift+v"
xdotool sleep 0.4 key --clearmodifiers "Return"
xdotool sleep 0.4 key --clearmodifiers "Return"

