#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

FILE_LAST_TIMESTAMP=".compress-screenshots-last-timestamp"
FILE_LOCK_COMPRESSION=".compress-screenshots-lock"

# human-readable conditions by qzb (https://github.com/qzb/is.sh)
source "$SCRIPT_DIR/is"

function echoerr {
  printf "%s\n" "$*" >&2;
}

DIR_REL_PATH="$1"

if is empty "$DIR_REL_PATH"; then
  echoerr "Usage: $SCRIPT_NAME dir_path"
  exit 10
fi

DIR_ABS_PATH=$(readlink -f "$DIR_REL_PATH")

cd "$DIR_ABS_PATH"


if [[ -f "$FILE_LOCK_COMPRESSION" ]]; then
  ERR="Can't compress screenshots folder! Remove \"$FILE_LOCK_COMPRESSION\" from the directory"
  echo $ERR;
  notify-send -u normal "$ERR"

  exit
fi

touch "$FILE_LOCK_COMPRESSION"

LAST_TIMESTAMP=$(cat "$FILE_LAST_TIMESTAMP")

if [[ -z "$LAST_TIMESTAMP" ]]; then
  LAST_TIMESTAMP=0
fi

for FILE in $(ls -rt *.png); do
    TIMESTAMP=$(stat -c %.Y "$FILE")
    NEW_FILE=$(echo "$TIMESTAMP > $LAST_TIMESTAMP" | bc -l)
    if [[ ! -f "$FILE" ]]; then
        echo "Error reading file \"$FILE\""
        exit 1
    fi
    if [[ $NEW_FILE == "1" ]]; then
        echo "Processing \"$FILE\""
        bash "$SCRIPT_DIR/compress-screenshot.sh" "$FILE"
        echo
        echo "$TIMESTAMP" > "$FILE_LAST_TIMESTAMP"
    else
        echo "Skipping \"$FILE\""
    fi
done;

rm "$FILE_LOCK_COMPRESSION"
