#!/bin/bash
FILE_PATH_REL=$1

if [[ -z "${FILE_PATH_REL}" ]]; then
  echo "You must specify path to file"
fi

FILE_PATH=$(readlink -f "${FILE_PATH_REL}")
FILE_NAME=$(basename "${FILE_PATH}")
FILE_EXT_ONLY=$(echo "$FILE_NAME" | cut -d'.' -f2-)
FILE_NAME_ONLY=$(basename "$FILE_NAME" | cut -d'.' -f-1)
DIR_PATH=$(dirname "${FILE_PATH}")

# OUTPUT_PATH="${DIR_PATH}/${FILE_NAME_ONLY}.png"

# if [[ -f "$OUTPUT_PATH" ]]; then
  # echo "Output path already exits. Exitting"
  # exit 1
# fi

# ls -l "${FILE_PATH}" "${OUTPUT_PATH}"

mogrify -format png "$FILE_PATH_REL"

cd "$DIR_PATH"
ls -l ${FILE_NAME_ONLY}.*

