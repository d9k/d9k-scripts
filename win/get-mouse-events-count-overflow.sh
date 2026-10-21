#!/bin/bash

FILE_MOUSE_EVENT_COUNT_PATH="$HOME/.hw-mouse-events-count"

MOUSE_EVENTS_COUNT=$(cat $FILE_MOUSE_EVENT_COUNT_PATH 2>/dev/null)
MAX_MOUSE_EVENTS_COUNT=5

if [[ -z "$MOUSE_EVENTS_COUNT" ]]; then
  MOUSE_EVENTS_COUNT=0
fi

if [ $MOUSE_EVENTS_COUNT -gt $MAX_MOUSE_EVENTS_COUNT ]; then
  echo 1
  exit
fi

echo 0
