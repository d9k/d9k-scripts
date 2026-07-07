#!/bin/bash

# Constants
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

if [[ -z "$SRT_FIXER_CLI_PATH" ]]; then
  SRT_FIX_DIR_PATH="$HOME/repos/_dl/srt_fix"
  SRT_FIXER_CLI_PATH="$SRT_FIX_DIR_PATH/srt_fixer_cli.py"
fi

SRT_FIXER_DOWNLOAD_URL='https://github.com/bindestriche/srt_fix'

# Intermediate variables
SUBTITLE_INPUT_PATH="$1"

# Functions
function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: ${SCRIPT_NAME} SUBTITLE_INPUT_PATH"
  echoerr "ENV variables:"
  echoerr "  SRT_FIXER_CLI_PATH: path to srt_fixer_cli.py from $SRT_FIXER_DOWNLOAD_URL"
  exit "$EXIT_CODE"
}

# Commands
if [ "$#" -lt 1 ]; then
  help_exit 100
fi

if [[ ! -f "$SRT_FIXER_CLI_PATH" ]]; then
  echoerr "Error: executable not found at: $SRT_FIXER_CLI_PATH. You can download it from $SRT_FIXER_DOWNLOAD_URL"
  exit 200
fi

if [[ -z "$SUBTITLE_INPUT_PATH" ]]; then
  help_exit 300
fi

SUBTITLE_BACKUP_PATH="${SUBTITLE_INPUT_PATH}.bk"

if [[ ! -f "$SUBTITLE_INPUT_PATH" ]]; then
  echoerr "Error: input file not found: $SUBTITLE_INPUT_PATH"
  exit 400
fi

if [[ -e "$SUBTITLE_BACKUP_PATH" ]]; then
  echoerr "Error: backup file already exists: $SUBTITLE_BACKUP_PATH"
  exit 500
fi

mv "$SUBTITLE_INPUT_PATH" "$SUBTITLE_BACKUP_PATH"

python "$SRT_FIXER_CLI_PATH" -o "$SUBTITLE_INPUT_PATH" "$SUBTITLE_BACKUP_PATH"

( set -x; ls -l "$SUBTITLE_INPUT_PATH"* )
