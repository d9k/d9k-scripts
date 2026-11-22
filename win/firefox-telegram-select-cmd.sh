#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

COMMAND_NAME="$*"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=100
  fi

  echoerr "Usage: $SCRIPT_NAME COMMAND_NAME"
  exit $EXIT_CODE
}

if [[ -z "$COMMAND_NAME" ]]; then
  help_exit
fi

$SCRIPT_DIR/firefox-telegram-open-cmd-palette.sh

# xdotool type is very slow with the russian layout active (switches layout per symbol); paste from clipboard instead
sleep 0.35
$SCRIPT_DIR/input-fill-with-clipboard-paste.sh "$COMMAND_NAME"

sleep 0.2
xdotool sleep 0.05 key Down
sleep 0.15
xdotool sleep 0.05 key Return

