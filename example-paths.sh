#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

function echoerr {
  printf "%s\n" "$*" >&2;
}

function print_variable { VAR_NAME="$1"
  VALUE="${!VAR_NAME}"
  echoerr "$VAR_NAME: $VALUE"
}

print_variable SCRIPT_DIR
