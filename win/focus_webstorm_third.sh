#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

WINDOW_CLASS_WEBSTORM=jetbrains-webstorm
WINDOW_CLASS_IDEA=jetbrains-idea

WINDOW_NUMBER=3

${SCRIPT_DIR}/focus-window-by-class.sh --number "$WINDOW_NUMBER" "$WINDOW_CLASS_WEBSTORM"

if [[ "$?" != "0" ]]; then
  ${SCRIPT_DIR}/focus-window-by-class.sh --number "$WINDOW_NUMBER" "$WINDOW_CLASS_IDEA"
fi
