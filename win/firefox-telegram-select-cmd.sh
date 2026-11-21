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
ORIGINAL_CLIPBOARD="$(xclip -selection clipboard -o 2>/dev/null)"
printf "%s" "$COMMAND_NAME" | xclip -selection clipboard

sleep 0.5
xdotool sleep 0.05 key "Control_L+v"

# Restore original clipboard content
if [ -n "$ORIGINAL_CLIPBOARD" ]; then
  printf "%s" "$ORIGINAL_CLIPBOARD" | xclip -selection clipboard
fi

sleep 0.2
xdotool sleep 0.05 key Down
sleep 0.1
xdotool sleep 0.05 key Return

