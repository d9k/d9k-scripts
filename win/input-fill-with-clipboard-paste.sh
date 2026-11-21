#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

TEXT="$*"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=100
  fi

  echoerr "Usage: $SCRIPT_NAME TEXT"
  exit $EXIT_CODE
}

if [[ -z "$TEXT" ]]; then
  help_exit
fi

ORIGINAL_CLIPBOARD="$(xclip -selection clipboard -o 2>/dev/null)"
printf "%s" "$TEXT" | xclip -selection clipboard

# shift+Insert is layout-independent, unlike ctrl+v: 'v' keysym makes xdotool switch XKB group per keypress on russian layout
xdotool sleep 0.05 key shift+Insert

# Restore original clipboard content
if [ -n "$ORIGINAL_CLIPBOARD" ]; then
  printf "%s" "$ORIGINAL_CLIPBOARD" | xclip -selection clipboard
fi
