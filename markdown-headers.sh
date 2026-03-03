#!/bin/bash

function echoerr {
  printf "%s\n" "$*" >&2;
}

FILE="$1"

VAULT_PATH="$HOME/tx"

if [[ -z "$FILE" ]]; then
  echoerr "Error: markdown file path required"
  exit 1
fi 

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

cat "$FILE" | grep -E "^#" | sed 's|^# |\n# |'
