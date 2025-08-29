#!/bin/bash

win_id="$1"

if [[ -z "$win_id" ]]; then
  win_id=$(xdotool getactivewindow)
  echo $win_id
fi

xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x1, 0x0, 0x0" -id ${win_id}
