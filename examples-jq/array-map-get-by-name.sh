#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
JSON_FILE="${SCRIPT_DIR}/array-map.json"

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit {
  local EXIT_CODE="$1"
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=100
  fi

  echoerr "Usage: $SCRIPT_NAME NAME"
  echoerr "  NAME - name of the object to find in array-map.json"
  exit "$EXIT_CODE"
}

NAME="$1"

if [[ -z "$NAME" ]]; then
  help_exit 100
fi

if [[ ! -f "$JSON_FILE" ]]; then
  echoerr "Error: JSON file not found: $JSON_FILE"
  exit 200
fi

jq --arg name "$NAME" '.[] | select(.name == $name)' "$JSON_FILE"
