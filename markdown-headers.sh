#!/bin/bash

function echoerr {
  printf "%s\n" "$*" >&2;
}

FILE="$1"

if [[ -z "$1" ]]; then
  echoerr "Error: markdown file path required"
  exit 1
fi 

cat "$FILE" | grep -E "^#"
