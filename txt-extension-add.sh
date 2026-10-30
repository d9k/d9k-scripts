#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

FILE_PATH="$@"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME FILE_PATH"
  exit $EXIT_CODE
}

if [[ -z "$FILE_PATH" ]]; then
  help_exit 100
fi

if [[ ! -f "$FILE_PATH" ]]; then
  echoerr "Error: file \"$FILE_PATH\" does not exist"
  help_exit 200
fi

FILE_ABS_PATH="$(readlink -f "$FILE_PATH")"

TXT_FILE_ABS_PATH="${FILE_ABS_PATH}.txt"

if [[ -e "$TXT_FILE_ABS_PATH" ]]; then
  echoerr "Error: file \"$TXT_FILE_ABS_PATH\" already exists"
  exit 300
fi

cp "$FILE_ABS_PATH" "$TXT_FILE_ABS_PATH"

printf "%s" "$TXT_FILE_ABS_PATH" | xclip -selection clipboard

echo "\"$TXT_FILE_ABS_PATH\" was copied to clipboard"
