#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
FILE_KEYBOARD_SPEED_BOOST_PATH="$HOME/.hw-keyboard-boost"

TIMEOUT_S=5

TIMEOUT_MS=$(( $TIMEOUT_S*1000 ))

notify-send -t $TIMEOUT_MS "keyboard speed boost for $TIMEOUT_S seconds"

touch "$FILE_KEYBOARD_SPEED_BOOST_PATH"

xset r rate 300 120

sleep 4

$SCRIPT_DIR/hw-keyboard-fix-repeat-rate.sh

rm "$FILE_KEYBOARD_SPEED_BOOST_PATH"

