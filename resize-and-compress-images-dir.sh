#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

FILE_LOCK_COMPRESSION=".compress-images-dir-lock"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function cleanup_and_exit {
  rm -f "$FILE_LOCK_COMPRESSION"
  exit 20
}

function ask_continue { ACTION_NAME=$1
  if [[ -z "${ACTION_NAME}" ]]; then
    ACTION_NAME="continue"
  fi

  read -n 1 -r -p "(Press \"y\" to ${ACTION_NAME}): " INPUT

  echo >&2

  if [ "$INPUT" != "Y" ] && [ "$INPUT" != "y" ] && [ "$INPUT" != "д" ] && [ "$INPUT" != "Д" ]; then
    echo "Aborted."
    exit 1
  fi
}

DIR_REL_PATH="$1"

if [[ -z "$DIR_REL_PATH" ]]; then
  echoerr "Usage: $SCRIPT_NAME dir_path"
  exit 100
fi

DIR_ABS_PATH=$(readlink -f "$DIR_REL_PATH")

if [[ ! -d "$DIR_ABS_PATH" ]]; then
  echoerr "Error: directory \"$DIR_REL_PATH\" does not exist"
  exit 200
fi

cd "$DIR_ABS_PATH"
if [[ $? -ne 0 ]]; then
  echoerr "Error: cannot enter directory \"$DIR_ABS_PATH\""
  exit 300
fi

if [[ -f "$FILE_LOCK_COMPRESSION" ]]; then
  echoerr "Can't compress: remove \"$FILE_LOCK_COMPRESSION\" from the directory first"
  exit 400
fi

touch "$FILE_LOCK_COMPRESSION"
trap cleanup_and_exit EXIT INT TERM

IMAGES_FILES=$(find . -type f | grep -i -E '\.(jpg|jpeg)$')
IMAGES_FILES_COUNT=$(echo "$IMAGES_FILES" | grep -c .)

if [[ -z "$IMAGES_FILES" ]]; then
  echo "No JPEG files found in \"$DIR_ABS_PATH\""
  exit 0
fi

echo "Files to compress:"
echo "$IMAGES_FILES" | sed 's/^/  /'
echo

echo "Found $IMAGES_FILES_COUNT JPEG file(s) in \"$DIR_ABS_PATH\""
ask_continue "compress these files?"

echo "$IMAGES_FILES" | while read -r FILE; do
  FILE_NAME=$(basename "$FILE")
  echo "Processing \"$FILE_NAME\""
  bash "$SCRIPT_DIR/resize-and-compress-image.sh" "$FILE"
  echo
done
