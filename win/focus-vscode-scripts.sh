#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

WINDOW_TITLE="scripts (Workspace)"

COMMAND="/home/d9k/scripts-private/scripts"

bash -c "$SCRIPT_DIR/focus-window-by-class.sh \"$WINDOW_TITLE\" \"$COMMAND\""