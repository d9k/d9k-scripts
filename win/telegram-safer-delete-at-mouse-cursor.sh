#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xdotool sleep 0.05 key Escape

sleep 0.2
$SCRIPT_DIR/telegram-copy-at-mouse-cursor.sh

sleep 0.2 
$SCRIPT_DIR/telegram-delete-at-mouse-cursor.sh
