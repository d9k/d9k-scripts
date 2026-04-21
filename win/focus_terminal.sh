#!/bin/bash

# See: wmctrl -lx
WINDOW_CLASS="org.wezfurlong.wezterm"
# COMMAND="xfce4-terminal &"
COMMAND="wezterm &"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
