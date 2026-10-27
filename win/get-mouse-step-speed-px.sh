#!/bin/bash

FILE_KEYBOARD_SPEED_BOOST_PATH="$HOME/.hw-keyboard-boost"
FILE_KEYBOARD_SPEED_SLOWDOWN_PATH="$HOME/.hw-keyboard-slowdown"

if [[ -f "$FILE_KEYBOARD_SPEED_BOOST_PATH" ]]; then
  echo 120
  exit
fi

if [[ -f "$FILE_KEYBOARD_SPEED_SLOWDOWN_PATH" ]]; then
  echo 8
  exit
fi

echo 22
