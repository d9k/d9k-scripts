#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$SCRIPT_DIR/firefox-telegram-switch-to-chat.sh "/2add/"

# The userscript searches the chat and clicks its row
sleep 2.5

# shift+Insert pastes the clipboard without touching it, and unlike ctrl+v it is layout-independent
xdotool key shift+Insert

sleep 0.2
xdotool key Return