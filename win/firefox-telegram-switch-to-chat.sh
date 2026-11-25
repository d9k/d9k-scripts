#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

CHAT_NAME="$1"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=100
  fi

  echoerr "Usage: $SCRIPT_NAME CHAT_NAME"
  exit $EXIT_CODE
}

if [[ -z "$CHAT_NAME" ]]; then
  help_exit
fi

$SCRIPT_DIR/firefox-telegram-run-command.sh "Ask chat name and switch"

# The userscript shows window.prompt() to ask the chat name
sleep 0.5

$SCRIPT_DIR/input-fill-with-clipboard-paste.sh "$CHAT_NAME"

sleep 0.2
xdotool key Return

