#!/bin/bash

WINDOW_CLASS="$1"
#WINDOW_CLASS=Terminal
COMMAND="$2"

if [[ -z "$WINDOW_CLASS" ]]; then
  echo "$WINDOW_CLASS not set"
fi

# -x: + WIN CLASS
WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n 1p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
  $COMMAND
  exit
fi

WMCTRL_NUMBER=$(printf "%d\n" ${WMCTRL_NUMBER})
echo WMCTRL_NUMBER: ${WMCTRL_NUMBER}


FOCUSED_WMCTRL_NUMBER=$(xdotool getwindowfocus)
echo FOCUSED_WMCTRL_NUMBER: ${FOCUSED_WMCTRL_NUMBER}

if [[ "$FOCUSED_WMCTRL_NUMBER" == "$WMCTRL_NUMBER" ]]; then
  ALREADY_FOCUSED=1
fi


if [ -n "$ALREADY_FOCUSED" ]; then
  set -x
  #wmctrl -b toggle,shaded -a ${WMCTRL_NUMBER}
  xdotool windowminimize ${WMCTRL_NUMBER}
else
  set -x
  # -v: verbose
  # -i: int value, not caption text
  # -a: activate
  wmctrl -v -i -a  ${WMCTRL_NUMBER}
fi
