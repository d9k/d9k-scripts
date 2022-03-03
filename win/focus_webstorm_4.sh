#!/bin/bash

WINDOW_CLASS="jetbrains-webstorm"

WINDOW_NUMBER=4

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

${SCRIPT_DIR}/focus-window-by-class.sh --number ${WINDOW_NUMBER} "$WINDOW_CLASS"
