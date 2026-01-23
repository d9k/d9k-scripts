#!/bin/bash

WINDOW_CLASS="$1"

if [[ -z "$WINDOW_CLASS" ]]; then
  echo "Error: window class not defined"
  exit 1
fi

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

function echoerr {                                                                      
  printf "%s\n" "$*" >&2;             
}

WINDOW_ID_DEC=$(${SCRIPT_DIR}/window-get-decimal-id-by-class.sh "$WINDOW_CLASS")

if [[ -z "$WINDOW_ID_DEC" ]]; then
  echoerr "Window with class \"${WINDOW_CLASS}\" was not found"
  exit
fi

${SCRIPT_DIR}/border-remove.sh "$WINDOW_ID_DEC"
