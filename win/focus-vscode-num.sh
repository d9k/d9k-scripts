#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

WINDOW_NUMBER="$1"

WINDOW_CLASS="code\.Code"

if [[ -z "$WINDOW_NUMBER" ]]; then
  WINDOW_NUMBER=1
fi

function echoerr {                                                                      
  printf "%s\n" "$*" >&2;             
}

WMCTRL_SEARCH_OUTPUT=$(\
  wmctrl -lx | \
  grep ${WINDOW_CLASS} | \
  # исключения \
  grep -v "diary (Workspace)" | \
  grep -v "scripts (Workspace)" | \
  grep -v "textbook (Workspace)" | \
  sed -n ${WINDOW_NUMBER}p \
)

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
  echoerr "Windows with class \"$WINDOW_CLASS\" not found"
  exit
fi

bash -c "$SCRIPT_DIR/focus-window-by-id.sh $WMCTRL_NUMBER"