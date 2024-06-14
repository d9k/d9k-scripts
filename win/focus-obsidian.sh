#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

WINDOW_CLASS="obsidian.obsidian"

#COMMAND="/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=obsidian.sh --file-forwarding md.obsidian.Obsidian"
# COMMAND="obsidian"
COMMAND="obsidian obsidian://open/?vault=tx"

bash -c "$SCRIPT_DIR/focus-window-by-class.sh \"$WINDOW_CLASS\" \"$COMMAND\""
