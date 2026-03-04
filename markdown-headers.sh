#!/bin/bash

# -n to show line numbers (passed to grep)

function echoerr {
  printf "%s\n" "$*" >&2;
}

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

# cat "$FILE" | grep -E "^#" | sed 's|^# |\n# |'
cat "$FILE" \
  | grep $(printf '%s\n' "$*") -E "^#" \
  | sed 's|^# |\n# |' \
  | sed -E "s|^([[:digit:]]+):|\1 ..... |"
