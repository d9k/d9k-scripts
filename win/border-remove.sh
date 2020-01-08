#!/bin/bash

win_id=$(xdotool getactivewindow)
echo $win_id
xprop -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x0, 0x0, 0x0" -id ${win_id}
