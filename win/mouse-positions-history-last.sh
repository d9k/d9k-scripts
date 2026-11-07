#!/bin/bash

MOUSE_POS_LOG_PATH="$HOME/.mouse-pos-history.json.log"

if [[ ! -s "$MOUSE_POS_LOG_PATH" ]]; then
  exit 0
fi

tail --lines 1 "$MOUSE_POS_LOG_PATH"
