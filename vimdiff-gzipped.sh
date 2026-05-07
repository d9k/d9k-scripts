#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

DECOMPRESSED_FILES=()

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=100
  fi

  echoerr "Usage: $SCRIPT_NAME FILE_A FILE_B"
  echoerr
  echoerr "Compare two files using nvim -R -d. Supports .gz files."
  exit "$EXIT_CODE"
}

function ask_continue { ACTION_NAME="$1"
  if [[ -z "${ACTION_NAME}" ]]; then
    ACTION_NAME="continue"
  fi

  read -n 1 -r -p "(Press \"y\" to ${ACTION_NAME}): " INPUT

  echo >&2

  if [ "$INPUT" != "Y" ] && [ "$INPUT" != "y" ] && [ "$INPUT" != "д" ] && [ "$INPUT" != "Д" ]; then
    echo "Aborted."
    exit 0
  fi
}

function cleanup_decompressed {
  if [[ ${#DECOMPRESSED_FILES[@]} -gt 0 ]]; then
    echo
    DECOMPRESSED_LIST=""
    for DECOMPRESSED_FILE in "${DECOMPRESSED_FILES[@]}"; do
      DECOMPRESSED_LIST="${DECOMPRESSED_LIST} $DECOMPRESSED_FILE"
    done
    ask_continue "DELETE decompressed files:${DECOMPRESSED_LIST}?"

    for DECOMPRESSED_FILE in "${DECOMPRESSED_FILES[@]}"; do
      rm -f "$DECOMPRESSED_FILE"
    done

    echo "Decompressed files removed."
  fi
}

trap cleanup_decompressed EXIT

function get_file_extension { FILE_PATH="$1"
  echo "$FILE_PATH" | rev | cut -f 1 -d '.' | rev
}

function get_filename_without_ext { FILE_PATH="$1"
  local FILE_EXTENSION
  FILE_EXTENSION=$(get_file_extension "$FILE_PATH")
  echo "$FILE_PATH" | sed -e "s|.${FILE_EXTENSION}$||g"
}

function decompress_if_gz { FILE_PATH="$1"
  local FILE_EXTENSION
  FILE_EXTENSION=$(get_file_extension "$FILE_PATH")

  if [[ "$FILE_EXTENSION" == "gz" ]]; then
    gunzip -k "$FILE_PATH"
    if [[ $? -ne 0 ]]; then
      echoerr "Error: failed to decompress $FILE_PATH"
      return 1
    fi
    get_filename_without_ext "$FILE_PATH"
  else
    echo "$FILE_PATH"
  fi

  return 0
}

FILE_A_INPUT="$1"
FILE_B_INPUT="$2"

if [[ -z "$FILE_A_INPUT" ]] || [[ -z "$FILE_B_INPUT" ]]; then
  help_exit 100
fi

if [[ ! -f "$FILE_A_INPUT" ]]; then
  echoerr "Error: file not found: $FILE_A_INPUT"
  exit 200
fi

if [[ ! -f "$FILE_B_INPUT" ]]; then
  echoerr "Error: file not found: $FILE_B_INPUT"
  exit 300
fi

FILE_A_FOR_DIFF=$(decompress_if_gz "$FILE_A_INPUT")
if [[ $? -ne 0 ]]; then
  exit 600
fi
if [[ "$FILE_A_FOR_DIFF" != "$FILE_A_INPUT" ]]; then
  DECOMPRESSED_FILES+=("$FILE_A_FOR_DIFF")
fi

FILE_B_FOR_DIFF=$(decompress_if_gz "$FILE_B_INPUT")
if [[ $? -ne 0 ]]; then
  exit 700
fi
if [[ "$FILE_B_FOR_DIFF" != "$FILE_B_INPUT" ]]; then
  DECOMPRESSED_FILES+=("$FILE_B_FOR_DIFF")
fi

nvim -R -d "$FILE_A_FOR_DIFF" "$FILE_B_FOR_DIFF"
