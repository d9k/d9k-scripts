#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

function echoerr {                                                                      
  printf "%s\n" "$*" >&2;             
}   

echo_help() {
  echoerr "Help: ${SCRIPT_NAME} WMCTRL_NUMBER
* WMCTRL_NUMBER: get by running: wmctrl -lx (first column)
  "
}

WMCTRL_NUMBER="$1"

if [[ -z "$WMCTRL_NUMBER" ]]; then
  echo_help
  exit
fi

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
