#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function echoerr { printf "%s\n" "$*" >&2; }

$SCRIPT_DIR/firefox-telegram-message-copy-link.sh

# The palette action is asynchronous: wait for the userscript to copy the link into the clipboard
# sleep 2
sleep 0.5

LINK="$(xclip -selection clipboard -o)"
if [[ -z "$LINK" ]]; then
  echoerr "Error: nothing copied to clipboard!"
  exit 100
fi

google-chrome "$LINK"
