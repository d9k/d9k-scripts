#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

IS_FOCUSED="$SCRIPT_DIR/is-window-by-class-focused.sh"

if [[ -n "$($IS_FOCUSED Terminal)" ]]; then
  sh "$SCRIPT_DIR/emulate-tmux-previous-window.sh"
  exit
fi

if [[ -n "$($IS_FOCUSED jetbrains)" ]]; then
  sh "$SCRIPT_DIR/emulate-ctrl-pageup.sh"
  exit
fi

sh "$SCRIPT_DIR/emulate-ctrl-shift-tab.sh"
