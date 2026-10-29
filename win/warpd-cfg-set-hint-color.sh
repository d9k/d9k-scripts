#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
CONFIG_ABS_PATH="$HOME/.config/warpd/config"
BACKUP_ABS_PATH="${CONFIG_ABS_PATH}.bk"
HINT_FGCOLOR_KEY="hint_fgcolor"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: ${SCRIPT_NAME} HINT_FGCOLOR"
  exit "$EXIT_CODE"
}

if [ "$#" -ne 1 ]; then
  help_exit 100
fi

HINT_FGCOLOR="$1"

if [ ! -f "$CONFIG_ABS_PATH" ]; then
  echoerr "Error: config file \"$CONFIG_ABS_PATH\" not found"
  exit 200
fi

HINT_FGCOLOR_LINE="${HINT_FGCOLOR_KEY}: ${HINT_FGCOLOR}"

if [ "$(grep --fixed-strings "$HINT_FGCOLOR_LINE" "$CONFIG_ABS_PATH")" = "$HINT_FGCOLOR_LINE" ]; then
  echo "${HINT_FGCOLOR_KEY} is already \"${HINT_FGCOLOR}\" in $CONFIG_ABS_PATH"
  exit 0
fi

cp "$CONFIG_ABS_PATH" "$BACKUP_ABS_PATH"

if grep --quiet "^${HINT_FGCOLOR_KEY}:" "$CONFIG_ABS_PATH"; then
  sed --in-place "s|^${HINT_FGCOLOR_KEY}:.*|${HINT_FGCOLOR_KEY}: ${HINT_FGCOLOR}|" "$CONFIG_ABS_PATH"
else
  printf "%s: %s\n" "$HINT_FGCOLOR_KEY" "$HINT_FGCOLOR" >> "$CONFIG_ABS_PATH"
fi

echo "Updated ${HINT_FGCOLOR_KEY} in $CONFIG_ABS_PATH"
