#!/bin/bash

# -n to show line numbers (passed to grep)

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1"
  echo "Usage: markdown-headers.sh [-n] FILE_PATH"
  echo "  -n: show lines numbers"
  exit "$EXIT_CODE"
}

# Arguments count check
if [ "$#" -lt 1 ]; then
  help_exit 1
fi

# echo "$@"
# echo
# FILE="$1"
# argv=( "$@" )
FILE="${!#}"
# argv=("${@:0:$#-1}")



VAULT_PATH="$HOME/tx"

if [[ -z "$FILE" ]]; then
  echoerr "Error: markdown file path required"
  exit 1
fi 

# Strip the last arg
set -- "${@:1:$#-1}"
# unset 'argv[-1]'
# echo "${argv[@]}"
# echo "$@"
# echo
# printf '%s\n' "$*"
# echo
# echo "FILE=$FILE"
# exit

GREP_ARGS=()

while [[ $# > 0 ]]; do
    OPTION="$1"

    case "$OPTION" in
        -n|--line-number)
            SHOW_LINE_NUMBERS=1
            GREP_ARGS+=('--line-number')
            shift # past argument
        ;;
        *)
          if [[ "${OPTION:0:1}" == "-" ]]; then
            echo -e "Error: unknown option \"$OPTION\" \n"
            help_exit
          else
            break
          fi
        ;;
    esac
    shift # past argument or value
done

if [[ ! -f "$FILE" ]]; then
  FILE_PATH_IN_VAULT="$VAULT_PATH/$FILE"
  if [[ -f "$FILE_PATH_IN_VAULT" ]]; then
     echoerr "Found file in the text vault: \"$FILE_PATH_IN_VAULT\""  
     FILE="$FILE_PATH_IN_VAULT"
  else
     echoerr "File not found"
     exit 2
  fi
fi

# set -x

# cat "$FILE" | grep -E "^#" | sed 's|^# |\n# |'
cat "$FILE" \
  | grep $(printf '%s ' "$GREP_ARGS") -E "^#" \
  | sed 's|^# |\n# |' \
  | sed -E "s|^([[:digit:]]+):|\1 ..... |"

LINES_COUNT=$(cat -n "$FILE" | cut -f1 | wc -l)

if [ -n "$SHOW_LINE_NUMBERS" ]; then
  # echo "Total lines: $LINES_COUNT"
  echo "$LINES_COUNT ..... (last line of file)"
fi
