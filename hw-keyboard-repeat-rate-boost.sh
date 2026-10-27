#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
FILE_KEYBOARD_SPEED_BOOST_PATH="$HOME/.hw-keyboard-boost"
FILE_KEYBOARD_SPEED_SLOWDOWN_PATH="$HOME/.hw-keyboard-slowdown"

TIMEOUT_S=5

TIMEOUT_MS=$(( $TIMEOUT_S*1000 ))

notify-send -t $TIMEOUT_MS "keyboard speed boost for $TIMEOUT_S seconds"

START_DATE=$(date --rfc-3339=seconds)
echo "$START_DATE" > "$FILE_KEYBOARD_SPEED_BOOST_PATH"
rm $FILE_KEYBOARD_SPEED_SLOWDOWN_PATH

xset r rate 300 120

sleep 4

$SCRIPT_DIR/hw-keyboard-fix-repeat-rate.sh

if [ ! -f "$FILE_KEYBOARD_SPEED_BOOST_PATH" ]; then 
  echo "$FILE_KEYBOARD_SPEED_BOOST_PATH is not file"
  exit
fi

DATE_IN_FILE=$(cat "$FILE_KEYBOARD_SPEED_BOOST_PATH")

if [[ "$DATE_IN_FILE" != "$START_DATE" ]]; then
  echo "Date in file differs. Created by another process, so keeping file"
  exit
fi

rm "$FILE_KEYBOARD_SPEED_BOOST_PATH"

