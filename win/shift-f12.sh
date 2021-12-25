#!/bin/bash

sleep 0.02
# if doesn't work, uncomment:
#sleep 0.2

xdotool keyup Shift_L Shift_R

# sudo apt install libnotify-bin
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#A=$(bash $SCRIPT_DIR/is-window-by-class-focused.sh jetbrains)
#
#echo "$A"

IS_FOCUSED="$SCRIPT_DIR/is-window-by-class-focused.sh"

# press alt+~
function xdotool_same_app_windows_cycle {
  xdotool keydown alt
  xdotool key asciitilde
  xdotool keyup alt
}

function xdotool_tmux_next_pane {
  xdotool key "ctrl+a"
  xdotool key "o"
  exit
}

function xdotool_send_copyq_paste {
  xdotool key "ctrl+Super_R+v"
  exit
}

if [[ -n "$($IS_FOCUSED google-chrome DevTools)" ]]; then
  xdotool_same_app_windows_cycle
  exit
fi

if [[ -n "$($IS_FOCUSED jetbrains)" ]]; then
  #notify-send jetbrains
  #xdotool_same_app_windows_cycle
  xdotool_send_copyq_paste
  exit
fi

if [[ -n "$($IS_FOCUSED Textadept)" ]]; then
  xdotool_send_copyq_paste
  exit
fi

if [[ -n "$($IS_FOCUSED jetbrains)" ]]; then
  #notify-send jetbrains
  xdotool_same_app_windows_cycle
  exit
fi

if [[ -n "$($IS_FOCUSED Terminal)" ]]; then
  #notify-send Terminal
  xdotool_tmux_next_pane
  exit
fi

xdotool key F12

