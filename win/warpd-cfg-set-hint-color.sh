#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

# To speed up warpd config reload replace `get_next_xev(100)` to `get_next_xev(8)` in warpd source, `do make; sudo make install``.
CONFIG_ABS_PATH="$HOME/.config/warpd/config"

BACKUP_ABS_PATH="${CONFIG_ABS_PATH}.bk"
HINT_FGCOLOR_KEY="hint_fgcolor"
DEFAULT_COLOR="#00FF00"

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

# if [ "$#" -ne 1 ]; then
#   help_exit 100
# fi

HINT_FGCOLOR="$1"

if [ -z "$HINT_FGCOLOR" ]; then
  HINT_FGCOLOR="$DEFAULT_COLOR"
fi

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
