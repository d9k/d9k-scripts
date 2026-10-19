#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
COMMANDS_PREFIX="${SCRIPT_NAME%.sh}-"
DEFAULT_COMMAND="run"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

function list_commands {
  local SCRIPT_PATH COMMAND_NAME
  for SCRIPT_PATH in "$SCRIPT_DIR/${COMMANDS_PREFIX}"*.sh; do
    [[ -e "$SCRIPT_PATH" ]] || continue
    COMMAND_NAME="$(basename "$SCRIPT_PATH" .sh | sed "s|^${COMMANDS_PREFIX}||")"
    echoerr "  $COMMAND_NAME"
  done
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME [COMMAND] [ARGS...]"
  echoerr
  echoerr "Runs adjacent script \"$SCRIPT_DIR/${COMMANDS_PREFIX}COMMAND.sh\""
  echoerr "passing the remaining ARGS to it."
  echoerr "Default COMMAND is \"$DEFAULT_COMMAND\"."
  echoerr
  echoerr "Available COMMANDs:"
  list_commands

  exit $EXIT_CODE
}

if [[ $# -eq 0 ]]; then
  COMMAND="$DEFAULT_COMMAND"
else
  COMMAND="$1"
  shift
fi

if [[ "$COMMAND" == "help" || "$COMMAND" == "list" || "$COMMAND" == "-h" || "$COMMAND" == "--help" ]]; then
  help_exit 0
fi

TARGET_SCRIPT_PATH="$SCRIPT_DIR/${COMMANDS_PREFIX}${COMMAND}.sh"

if [[ ! -f "$TARGET_SCRIPT_PATH" ]]; then
  echoerr "Error: unknown command \"$COMMAND\", no script \"$TARGET_SCRIPT_PATH\""
  echoerr
  help_exit 100
fi

exec "$TARGET_SCRIPT_PATH" "$@"
