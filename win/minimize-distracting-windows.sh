#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

MINIMIZE_SCRIPT="$SCRIPT_DIR/minimize-window-by-class.sh"

WINDOW_CLASSES=(
  "Chrome Proxy"
  "Chrome Audio"
  "discord.discord"
)

for (( ix=0 ; ix<${#WINDOW_CLASSES[@]} ; ix++ )); do
  WINDOW_CLASS="${WINDOW_CLASSES[ix]}"
  ( set -x; bash -c "$MINIMIZE_SCRIPT '$WINDOW_CLASS'" )
done

