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

eval "$(xdotool getmouselocation --shell)"

$SCRIPT_DIR/firefox-telegram-select-cmd.sh "Message: ask chat name to repost"

# The userscript shows window.prompt() to ask the chat name
sleep 0.5

$SCRIPT_DIR/input-fill-with-clipboard-paste.sh "$CHAT_NAME"

sleep 0.2
xdotool key Return

# The userscript searches the chat, clicks the row and presses Enter to send the message
sleep 3

# yad --question pre-selects the No button, so Enter would cancel the move;
# explicit buttons make the Enter key activate the first declared one, therefore Yes comes first
yad \
  --no-markup \
  --on-top \
  --justify=center \
  --align=center \
  --margins=20 \
  --wrap \
  --mouse \
  --title="Did it moved correct?" \
  --text="Proceed to remove original record" \
  --button="gtk-yes:0" \
  --button="gtk-no:1"

YAD_ANSWER_CODE=$?

# Close the leftover repost dialog
$SCRIPT_DIR/emulate-escape-key.sh

if [ $YAD_ANSWER_CODE -ne 0 ]; then
  exit 100
fi

xdotool mousemove $X $Y

sleep 1
$SCRIPT_DIR/firefox-telegram-message-delete.sh
