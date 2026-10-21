#!/bin/bash

FILE_KEYBOARD_SPEED_BOST_PATH="$HOME/.hw-keyboard-boost"

if [[ -f "$FILE_KEYBOARD_SPEED_BOST_PATH" ]]; then
  echo 120
  exit
fi

echo 22
