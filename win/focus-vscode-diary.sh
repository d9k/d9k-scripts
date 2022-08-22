#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

WINDOW_TITLE="diary (Workspace)"

COMMAND="/home/d9k/scripts-private/diary"

bash -c "$SCRIPT_DIR/focus-window-by-class.sh \"$WINDOW_TITLE\" \"$COMMAND\""