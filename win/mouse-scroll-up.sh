#!/bin/sh

# Require to unassign Start Menu from Win key to work without "keyup Super"!
#xdotool keyup Super
#sleep 0.1

FILE_KEYBOARD_SPEED_BOST_PATH="$HOME/.hw-keyboard-boost"

SCROLL_COUNT=$1
SCROLL_COUNT_BOOSTED=$2

if [ -z "$SCROLL_COUNT" ]; then
  SCROLL_COUNT=1
fi

if [ -z "$SCROLL_COUNT_BOOSTED" ]; then
  SCROLL_COUNT_BOOSTED=$(( $SCROLL_COUNT * 2 ))
fi

# echo $SCROLL_COUNT_BOOSTED

SCROLL_COUNT_ACTUAL=$SCROLL_COUNT

if test -f "$FILE_KEYBOARD_SPEED_BOST_PATH"; then
  SCROLL_COUNT_ACTUAL="$SCROLL_COUNT_BOOSTED"
fi 

# https://unix.stackexchange.com/questions/505833/how-do-ranges-in-dash-work
i=1
while [ "$i" -le $SCROLL_COUNT_ACTUAL ]; do
  xdotool click 4
  sleep 0.05
  echo "scroll up $i" >> /tmp/t
  i=$(( i + 1 ))
done

