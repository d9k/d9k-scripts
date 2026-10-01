#!/bin/bash

GAMEDEV_DIR=$HOME/cr/ga
VAULT_PATH=$(obsidian-get-default-vault-path)
VAULT_GAMES_PATH="$VAULT_PATH/ga"

SOURCE_FILE_PATH="$1"

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1"
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME SOURCE_FILE_PATH"
  exit $EXIT_CODE
}

if [[ -z "$SOURCE_FILE_PATH" ]]; then
  help_exit 100
fi

SOURCE_FILE_PATH_ABS=$(realpath -m "$SOURCE_FILE_PATH")

SOURCE_FILE_PATH_RELATIVE=$(realpath --relative-to="$GAMEDEV_DIR" "$SOURCE_FILE_PATH_ABS")

if [[ "$SOURCE_FILE_PATH_RELATIVE" == "../"* || "$SOURCE_FILE_PATH_RELATIVE" == ".." ]]; then
  echoerr "Error: SOURCE_FILE_PATH argument \"$SOURCE_FILE_PATH_ABS\" must be inside GAMEDEV_DIR \"$GAMEDEV_DIR\""
  exit 200
fi

SOURCE_DIR_RELATIVE=$(dirname "$SOURCE_FILE_PATH_RELATIVE")

TARGET_FILE_PATH="$VAULT_GAMES_PATH/$SOURCE_FILE_PATH_RELATIVE"
TARGET_DIR=$(dirname "$TARGET_FILE_PATH")

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Creating TARGET_DIR: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
fi

if [[ -e "$TARGET_FILE_PATH" || -L "$TARGET_FILE_PATH" ]]; then
  ls -l "$TARGET_FILE_PATH"
  echoerr "Error: TARGET_FILE_PATH already exists: $TARGET_FILE_PATH"
  exit 300
fi

ln -s "$SOURCE_FILE_PATH_ABS" "$TARGET_FILE_PATH"

ls -l "$TARGET_FILE_PATH"
