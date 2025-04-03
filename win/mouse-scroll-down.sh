#!/bin/sh

# Require to unassign Start Menu from Win key to work without "keyup Super"!
#xdotool keyup Super
#sleep 0.1

SCROLL_COUNT=$1

if [[ -z "$SCROLL_COUNT" ]]; then
  SCROLL_COUNT=1
fi

# https://unix.stackexchange.com/questions/505833/how-do-ranges-in-dash-work
i=1
while [ "$i" -le $SCROLL_COUNT ]; do
  xdotool click 5
  sleep 0.05
  i=$(( i + 1 )) 
done

