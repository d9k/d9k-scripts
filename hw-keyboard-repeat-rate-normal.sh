#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
FILE_KEYBOARD_SPEED_BOOST_PATH="$HOME/.hw-keyboard-boost"
FILE_KEYBOARD_SPEED_SLOWDOWN_PATH="$HOME/.hw-keyboard-slowdown"

rm "$FILE_KEYBOARD_SPEED_BOOST_PATH"
rm "$FILE_KEYBOARD_SPEED_SLOWDOWN_PATH"
$SCRIPT_DIR/hw-keyboard-fix-repeat-rate.sh
