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

# The userscript searches the chat, asks for target chat name,
# clicks the chat name row and clicks send message button
$SCRIPT_DIR/firefox-telegram-select-cmd.sh "Message: ask chat name to repost"

# The userscript shows window.prompt() to ask the chat name
sleep 0.5

$SCRIPT_DIR/input-fill-with-clipboard-paste.sh "$CHAT_NAME"

# Confirm pasted target chat name with pressing Return key
sleep 0.2
xdotool key Return

# sleep 1.5
# sleep 3.0
# sleep 10.0
sleep 7.0

# Escape closes the leftover repost dialog and returns back to the previous chat.
$SCRIPT_DIR/emulate-escape-key.sh
# sleep 0.2
# $SCRIPT_DIR/emulate-escape-key.sh

# $SCRIPT_DIR/emulate-escape-key.sh
