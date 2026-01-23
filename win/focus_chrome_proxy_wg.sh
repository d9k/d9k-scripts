#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# WINDOW_CLASS="chrome-data-dir-audio-proxy"
# WINDOW_CLASS="Chrome Proxy Wg"
WINDOW_CLASS="chrome-data-dir-proxy-wg"

COMMAND="$HOME/scripts/chrome-proxy-wg"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
