#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

WINDOW_CLASS="sound.cinnamon-setting"
OPACITY=90

COMMAND="cinnamon-settings sound &"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"

if [ "$?" -eq "1" ]; then
  echo "Command was executed"
  sleep 1.5
  $SCRIPT_DIR/set-opacity.sh $OPACITY "$WINDOW_CLASS"
fi
