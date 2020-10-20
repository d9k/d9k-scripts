#!/bin/bash

# wmctrl -lx
WINDOW_CLASS="Slack"

COMMAND="/$HOME/scripts/slack-fix-suspend"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "$SCRIPT_DIR"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
