#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# human-readable conditions by qzb (https://github.com/qzb/is.sh)
source "$SCRIPT_DIR/is"

MAX_ORIGINAL_ALLOWED_SIZE_KB=459
QUALITY=94

function echoerr {
  printf "%s\n" "$*" >&2;
}

function file_size_kb { FILE_PATH="$1"
  du -k "$FILE_PATH" | cut -f1
}

FILE_REL_PATH="$1"

if is empty "$FILE_REL_PATH"; then
  echoerr "Usage: $SCRIPT_NAME file_name"
  exit 10
fi

if is not file "$FILE_REL_PATH"; then
  echoerr "Error: \"$FILE_REL_PATH\" is not file"
  exit 15
fi

FILE_ABS_PATH=$(readlink -f "$FILE_REL_PATH")
FILE_DIR_PATH=$(dirname "$FILE_ABS_PATH")
FILE_NAME_WITH_EXT=$(basename "$FILE_REL_PATH")

FILE_EXTENSION=$(echo "$FILE_NAME_WITH_EXT" | rev | cut -f 1 -d '.' | rev)
FILE_NAME_NO_EXT=$(echo "$FILE_NAME_WITH_EXT" | sed -e s/\.${FILE_EXTENSION}$//g)

if [[ "$FILE_EXTENSION" != 'png' ]]; then
  echoerr "Error: extension .$FILE_EXTENSION is not supported"
  exit 20
fi

FILE_SIZE_KB=$(file_size_kb "$FILE_ABS_PATH")

if [ "$FILE_SIZE_KB" -le "$MAX_ORIGINAL_ALLOWED_SIZE_KB"  ]; then
  echo "Skipping compression: file size is just ${FILE_SIZE_KB}kb (<= ${MAX_ORIGINAL_ALLOWED_SIZE_KB}kb)"
  exit
fi

# if ! command -v cwebp &> /dev/null ;then
#     echoerr "cwebp command could not be found. Install webp package first"
#     exit 30
# fi

if ! command -v mozjpeg &> /dev/null ;then
    echoerr "mozjpeg command could not be found. Do \"npm install --global mozjpeg\" first"
    exit 30
fi

OUTPUT_PATH="$FILE_DIR_PATH/$FILE_NAME_NO_EXT.jpg"

# cwebp -q 100 "$FILE_ABS_PATH" -o "$OUTPUT_PATH" &> /dev/null

mozjpeg -quality "$QUALITY" -outfile "$OUTPUT_PATH" "$FILE_ABS_PATH"

OUTPUT_FILE_SIZE_KB=$(file_size_kb "$OUTPUT_PATH")

if [ "$OUTPUT_FILE_SIZE_KB" -lt "$FILE_SIZE_KB" ]; then
  PERCENT_DELTA_RAW=$(echo "($FILE_SIZE_KB-$OUTPUT_FILE_SIZE_KB)/$FILE_SIZE_KB*100" | bc -l)
  PERCENT_DELTA=$(printf %.0f "$PERCENT_DELTA_RAW")
#   echo "compression png -> webp: (-${PERCENT_DELTA}%: ${FILE_SIZE_KB}kb -> ${OUTPUT_FILE_SIZE_KB}kb)"
  echo "compression png -> jpg: (-${PERCENT_DELTA}%: ${FILE_SIZE_KB}kb -> ${OUTPUT_FILE_SIZE_KB}kb)"
  rm "$FILE_ABS_PATH" &> /dev/null
else
  echo "Compression was not useful. Deleting output file"
  rm "$OUTPUT_PATH" &> /dev/null
fi
