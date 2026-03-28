#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

WINDOW_CLASS="pulseeffects.Pulseeffects"
OPACITY=94

COMMAND="gio launch /var/lib/flatpak/exports/share/applications/com.github.wwmm.pulseeffects.desktop &"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"

if [ "$?" -eq "1" ]; then
  echo "Command was executed"
  SLEEP_BEFORE_RETRY_S=0.5
  RETRY_NUMBER=0
  MAX_RETRIES=20

  while [[ "$RETRY_NUMBER" -lt "$MAX_RETRIES" ]]; do
     $SCRIPT_DIR/set-opacity.sh $OPACITY "$WINDOW_CLASS"
     if [ "$?" -eq "0" ]; then
       exit
     fi

      ((RETRY_NUMBER+=1))
      sleep "$SLEEP_BEFORE_RETRY_S"
      echo "Window not found. Retry $RETRY_NUMBER"
   done
fi
