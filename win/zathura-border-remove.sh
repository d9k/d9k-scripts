#!/bin/bash

WINDOW_CLASS="Zathura"

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
