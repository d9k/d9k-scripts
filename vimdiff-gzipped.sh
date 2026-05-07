#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

DECOMPRESSED_FILES=()
ALL_FILES=()
DECOMPRESS_IF_GZ_RESULT=""

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

function show_files_ls {
  printf '%s\n' "${ALL_FILES[@]}" | xargs ls -l
}

function cleanup_decompressed {
  if [[ ${#DECOMPRESSED_FILES[@]} -gt 0 ]]; then
    echo
    echo "Before cleanup:"
    show_files_ls
    echo

    DECOMPRESSED_LIST=""
    for DECOMPRESSED_FILE in "${DECOMPRESSED_FILES[@]}"; do
      DECOMPRESSED_LIST="${DECOMPRESSED_LIST} $DECOMPRESSED_FILE"
    done
    ask_continue "DELETE decompressed files:${DECOMPRESSED_LIST}?"

    for DECOMPRESSED_FILE in "${DECOMPRESSED_FILES[@]}"; do
      rm -f "$DECOMPRESSED_FILE"
    done

    echo
    echo "After cleanup:"
    show_files_ls 2>/dev/null
    echo

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
  DECOMPRESS_IF_GZ_RESULT=""
  ALL_FILES+=("$FILE_PATH")
  FILE_EXTENSION=$(get_file_extension "$FILE_PATH")

  if [[ "$FILE_EXTENSION" == "gz" ]]; then
    DECOMPRESSED_PATH=$(get_filename_without_ext "$FILE_PATH")
    gunzip -k "$FILE_PATH"
    if [[ $? -ne 0 ]]; then
      echoerr "Error: failed to decompress $FILE_PATH"
      return 1
    fi
    ALL_FILES+=("$DECOMPRESSED_PATH")
    DECOMPRESSED_FILES+=("$DECOMPRESSED_PATH")
    DECOMPRESS_IF_GZ_RESULT="$DECOMPRESSED_PATH"
  else
    DECOMPRESS_IF_GZ_RESULT="$FILE_PATH"
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

decompress_if_gz "$FILE_A_INPUT"
if [[ $? -ne 0 ]]; then
  exit 600
fi
FILE_A_FOR_DIFF="$DECOMPRESS_IF_GZ_RESULT"

decompress_if_gz "$FILE_B_INPUT"
if [[ $? -ne 0 ]]; then
  exit 700
fi
FILE_B_FOR_DIFF="$DECOMPRESS_IF_GZ_RESULT"

nvim -R -d "$FILE_A_FOR_DIFF" "$FILE_B_FOR_DIFF"
