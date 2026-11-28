#!/bin/bash

# Use `wmctrl -lx` to see opened windows classes
# WINDOW_CLASS="Telegram"
# WINDOW_CLASS="Telegram Web"
WINDOW_CLASS="Navigator.Firefox-Telegram"

COMMAND="$HOME/scripts/firefox-telegram"
# COMMAND="flatpak run org.telegram.desktop --filesystem=/home/d9k,/run/user/1000 &"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "$SCRIPT_DIR"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
