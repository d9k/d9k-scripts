#!/bin/bash
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME [--override|-o] FILE_PATH"
  exit $EXIT_CODE
}

OVERRIDE=

while [[ $# -gt 0 ]]; do
  case "$1" in
    --override|-o)
      OVERRIDE=1
      shift
      ;;
    -h|--help)
      help_exit 0
      ;;
    -*)
      echoerr "Unknown option: $1"
      help_exit 100
      ;;
    *)
      break
      ;;
  esac
done

FILE_PATH_REL=$1

if [[ -z "${FILE_PATH_REL}" ]]; then
  echoerr "You must specify path to file"
  help_exit 200
fi

FILE_PATH=$(readlink -f "${FILE_PATH_REL}")
FILE_NAME=$(basename "${FILE_PATH}")
FILE_EXT_ONLY=$(echo "$FILE_NAME" | cut -d'.' -f2-)
FILE_NAME_ONLY=$(basename "$FILE_NAME" | cut -d'.' -f-1)
DIR_PATH=$(dirname "${FILE_PATH}")

OUTPUT_PATH="${DIR_PATH}/${FILE_NAME_ONLY}_utf.${FILE_EXT_ONLY}"

LS_ARGS=("${FILE_PATH}")

if [[ -n "$OVERRIDE" ]]; then
  iconv -f cp1251 -t utf8 "${FILE_PATH}" | sponge "${FILE_PATH}"
else
  iconv -f cp1251 -t utf8 "${FILE_PATH}" > "${OUTPUT_PATH}"
  LS_ARGS+=("${OUTPUT_PATH}")
fi

ls -l "${LS_ARGS[@]}"
