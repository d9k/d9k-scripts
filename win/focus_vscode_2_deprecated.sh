#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

WINDOW_CLASS="code\.Code"
WINDOW_NUMBER=2

${SCRIPT_DIR}/focus-window-by-class.sh --number ${WINDOW_NUMBER} "$WINDOW_CLASS"
