#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

function echoerr {
  printf "%s\n" "$*" >&2;
}

help_exit() {
  echoerr "Help: ${SCRIPT_NAME} WINDOW_CLASS 
  * WINDOW_CLASS: see by running: wmctrl -lx
  "
  exit 1
}

WINDOW_CLASS="$1"

if [[ -z "$WINDOW_CLASS" ]]; then
  echoerr "WINDOW_CLASS not set"
  help_exit
fi

# -x: + WIN CLASS
WMCTRL_SEARCH_OUTPUT=$($SCRIPT_DIR/wmctrl-list-reorder.sh -x | grep --fixed-strings "${WINDOW_CLASS}" | sed -n ${WINDOW_NUMBER}p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -n "$WMCTRL_NUMBER" ]]; then
    xdotool windowminimize "$WMCTRL_NUMBER"
else
    echoerr "Windows with class ${WINDOW_CLASS} was not found"
    exit 2
fi

WMCTRL_NUMBER=$(printf "%d\n" ${WMCTRL_NUMBER})
echo WMCTRL_NUMBER: ${WMCTRL_NUMBER}

