#!/bin/sh

# Require to unassign Start Menu from Win key to work without "keyup Super"!
#xdotool keyup Super
#sleep 0.1

SCROLL_COUNT=$1

if [[ -z "$SCROLL_COUNT" ]]; then
  SCROLL_COUNT=1
fi

for run in {1..SCROLL_COUNT}; do
  xdotool click 5
done

