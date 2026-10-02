#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

DECOMPRESSED_FILES=()
TEMP_DIRS=()
TEMP_BASE_DIRS=()
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
  echoerr "Compare two files using nvim -R -d."
  echoerr "Supports .gz files and .tar.gz / .tgz archives."
  echoerr
  echoerr "For .tar.gz / .tgz archives:"
  echoerr "  - creates ./temp/ near the compared files (in the dir of FILE_A)"
  echoerr "  - extracts each archive into ./temp/\$temp_dir_a / ./temp/\$temp_dir_b"
  echoerr "    (temp dir names are based on the archive base names)"
  echoerr "  - picks the most suitable file from each dir, priority:"
  echoerr "    .sql, .json, .log, .txt (falls back to any other file, incl. nested)"
  echoerr "  - offers to remove the temporary directories at the end"
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
  printf '%s\n' "${ALL_FILES[@]}" | xargs -d '\n' ls -l --
}

function cleanup_decompressed {
  if [[ ${#TEMP_DIRS[@]} -gt 0 ]]; then
    echo
    echo "Before cleanup:"
    show_files_ls
    echo

    echo "Temp directories:"
    for TEMP_DIR in "${TEMP_DIRS[@]}"; do
      echo "  $TEMP_DIR"
    done
    echo

    TEMP_DIR_LIST=""
    for TEMP_DIR in "${TEMP_DIRS[@]}"; do
      TEMP_DIR_LIST="${TEMP_DIR_LIST} '$TEMP_DIR'"
    done
    ask_continue "DELETE temp directories: rm -rf ${TEMP_DIR_LIST}?"

    for TEMP_DIR in "${TEMP_DIRS[@]}"; do
      rm -rf "$TEMP_DIR"
    done

    for TEMP_BASE_DIR in "${TEMP_BASE_DIRS[@]}"; do
      rmdir "$TEMP_BASE_DIR" 2>/dev/null
    done

    echo
    echo "After cleanup:"
    show_files_ls 2>/dev/null
    echo

    echo "Temp directories removed."
  fi

  if [[ ${#DECOMPRESSED_FILES[@]} -gt 0 ]]; then
    echo
    echo "Before cleanup:"
    show_files_ls
    echo

    DECOMPRESSED_LIST=""
    for DECOMPRESSED_FILE in "${DECOMPRESSED_FILES[@]}"; do
      DECOMPRESSED_LIST="${DECOMPRESSED_LIST} $DECOMPRESSED_FILE"
    done
    ask_continue "DELETE decompressed files: rm ${DECOMPRESSED_LIST}?"

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

function is_tar_gz { FILE_PATH="$1"
  case "$FILE_PATH" in
    *.tar.gz|*.tgz)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

function get_archive_base_name { FILE_PATH="$1"
  local BASE_NAME
  BASE_NAME="$(basename "$FILE_PATH")"
  echo "$BASE_NAME" | sed -e 's|\..*||'
}

function pick_file_from_dir { DIR_PATH="$1"
  local EXT
  local CANDIDATE=""

  # priority: .sql, .json, .log, .txt
  for EXT in sql json log txt; do
    CANDIDATE=$(find "$DIR_PATH" -type f -iname "*.$EXT" | sort | head -n 1)
    if [[ -n "$CANDIDATE" ]]; then
      echo "$CANDIDATE"
      return 0
    fi
  done

  # fallback: any other file (including nested ones)
  CANDIDATE=$(find "$DIR_PATH" -type f | sort | head -n 1)
  if [[ -n "$CANDIDATE" ]]; then
    echo "$CANDIDATE"
    return 0
  fi

  return 1
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

TEMP_BASE_DIR=""
TEMP_DIR_A=""
TEMP_DIR_B=""

if is_tar_gz "$FILE_A_INPUT" || is_tar_gz "$FILE_B_INPUT"; then
  TEMP_BASE_DIR="$(dirname "$FILE_A_INPUT")/temp"
  if ! mkdir -p "$TEMP_BASE_DIR"; then
    echoerr "Error: failed to create temp directory: $TEMP_BASE_DIR"
    exit 400
  fi
  TEMP_BASE_DIRS+=("$TEMP_BASE_DIR")
fi

# --- FILE A ---

if is_tar_gz "$FILE_A_INPUT"; then
  TEMP_DIR_A="$TEMP_BASE_DIR/$(get_archive_base_name "$FILE_A_INPUT")"
  ALL_FILES+=("$FILE_A_INPUT")

  if ! mkdir -p "$TEMP_DIR_A"; then
    echoerr "Error: failed to create temp directory: $TEMP_DIR_A"
    exit 500
  fi
  TEMP_DIRS+=("$TEMP_DIR_A")

  if ! tar -xzf "$FILE_A_INPUT" -C "$TEMP_DIR_A"; then
    echoerr "Error: failed to extract $FILE_A_INPUT into $TEMP_DIR_A"
    exit 600
  fi

  FILE_A_FOR_DIFF=$(pick_file_from_dir "$TEMP_DIR_A")
  if [[ -z "$FILE_A_FOR_DIFF" ]]; then
    echoerr "Error: no suitable file found in $TEMP_DIR_A"
    exit 800
  fi
  ALL_FILES+=("$FILE_A_FOR_DIFF")
else
  decompress_if_gz "$FILE_A_INPUT"
  if [[ $? -ne 0 ]]; then
    exit 600
  fi
  FILE_A_FOR_DIFF="$DECOMPRESS_IF_GZ_RESULT"
fi

# --- FILE B ---

if is_tar_gz "$FILE_B_INPUT"; then
  TEMP_DIR_B="$TEMP_BASE_DIR/$(get_archive_base_name "$FILE_B_INPUT")"
  if [[ -n "$TEMP_DIR_A" ]] && [[ "$TEMP_DIR_B" == "$TEMP_DIR_A" ]]; then
    TEMP_DIR_B="${TEMP_DIR_B}_b"
  fi
  ALL_FILES+=("$FILE_B_INPUT")

  if ! mkdir -p "$TEMP_DIR_B"; then
    echoerr "Error: failed to create temp directory: $TEMP_DIR_B"
    exit 550
  fi
  TEMP_DIRS+=("$TEMP_DIR_B")

  if ! tar -xzf "$FILE_B_INPUT" -C "$TEMP_DIR_B"; then
    echoerr "Error: failed to extract $FILE_B_INPUT into $TEMP_DIR_B"
    exit 700
  fi

  FILE_B_FOR_DIFF=$(pick_file_from_dir "$TEMP_DIR_B")
  if [[ -z "$FILE_B_FOR_DIFF" ]]; then
    echoerr "Error: no suitable file found in $TEMP_DIR_B"
    exit 900
  fi
  ALL_FILES+=("$FILE_B_FOR_DIFF")
else
  decompress_if_gz "$FILE_B_INPUT"
  if [[ $? -ne 0 ]]; then
    exit 700
  fi
  FILE_B_FOR_DIFF="$DECOMPRESS_IF_GZ_RESULT"
fi

echo "Diff: $FILE_A_FOR_DIFF <-> $FILE_B_FOR_DIFF"

nvim -R -d "$FILE_A_FOR_DIFF" "$FILE_B_FOR_DIFF"
