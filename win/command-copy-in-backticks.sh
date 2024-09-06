#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# TODO
xdotool sleep 0.2 key --clearmodifiers "Control_L+c"

CLIPBOARD=$(xsel -ob)

# Run code between back quotes only, if present (for markdown) ``
CLIPBOARD_FIXED=$(echo -e "$CLIPBOARD" |  cut -d "\`" -f2)

echo -e "$CLIPBOARD_FIXED" | xclip -selection c

