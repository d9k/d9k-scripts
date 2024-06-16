#!/bin/bash

# Use `wmctrl -lx` to see opened windows classes
WINDOW_CLASS="Telegram"
WINDOW_CLASS="TelegramDesktop"

#COMMAND="~/soft/Telegram/Telegram &"
COMMAND="flatpak run org.telegram.desktop &"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "$SCRIPT_DIR"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
