#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
FILE_KEYBOARD_SPEED_BOOST_PATH="$HOME/.hw-keyboard-boost"

rm "$FILE_KEYBOARD_SPEED_BOOST_PATH"
$SCRIPT_DIR/hw-keyboard-fix-repeat-rate.sh
