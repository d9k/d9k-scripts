#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Using absolute path to script because PATH often messed up
XKB_SWITCH="$SCRIPT_DIR/xkb-switch"
MAX_SWITCH_STEPS=10
LAYOUT_EN="en"
LAYOUT_US="us"

function echoerr {
  printf "%s\n" "$*" >&2;
}

for ((STEP=1; STEP<=MAX_SWITCH_STEPS; STEP++)); do
  sleep 0.1
  LAYOUT="$($XKB_SWITCH -p)"

  if [[ "$LAYOUT" == "$LAYOUT_EN" || "$LAYOUT" == "$LAYOUT_US" ]]; then
    exit 0
  fi

  $XKB_SWITCH -n
done

echoerr "Error: keyboard layout \"$LAYOUT\" is not switched to English after $MAX_SWITCH_STEPS steps"
exit 100
