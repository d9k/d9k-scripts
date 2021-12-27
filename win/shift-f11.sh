#!/bin/bash

sleep 0.02
# if doesn't work, uncomment:
#sleep 0.2

xdotool keyup Shift_L Shift_R

sleep 0.1

# sudo apt install libnotify-bin
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


IS_FOCUSED="$SCRIPT_DIR/is-window-by-class-focused.sh"

#if [[ -n "$($IS_FOCUSED Terminal)" ]]; then
#  #notify-send Terminal
#  #xdotool_tmux_next_pane
#  xdotool_tmux_next_window
#  sh "$SCRIPT_DIR/emulate-tmux-next-window.sh"
#  exit
#fi

sh "$SCRIPT_DIR/emulate-multimedia-previos.sh"

