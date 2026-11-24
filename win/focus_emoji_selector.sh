#!/bin/bash
# App built-in "Open emoji picker" keybinding worked glitchy sometimes

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTS="$HOME/scripts"

# See: wmctrl -lx
WINDOW_CLASS="emote.Emote"
# COMMAND="xfce4-terminal &"

# emote laucher
COMMAND="$SCRIPTS/emote-start"
# show"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
