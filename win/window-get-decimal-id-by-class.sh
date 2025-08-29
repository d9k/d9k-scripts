#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

WINDOW_CLASS="$1"

function echoerr {                                                                      
  printf "%s\n" "$*" >&2;             
}   

if [[ -z "$WINDOW_CLASS" ]]; then
  echoerr "WINDOW_CLASS not set"
  exit
fi

WMCTRL_SEARCH_OUTPUT=$($SCRIPT_DIR/wmctrl-list-reorder.sh -x | grep --fixed-strings "${WINDOW_CLASS}" | sed -n ${WINDOW_NUMBER}p)

# echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -n "$WMCTRL_NUMBER" ]]; then
  printf "%d\n" ${WMCTRL_NUMBER}
fi
