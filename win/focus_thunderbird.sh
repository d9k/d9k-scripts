#!/bin/bash

# use `wmctrl -lx` to find out
WIN_CLASS="Mail.Thunderbird"
RUN_APP="thunderbird"

wmctrl -x -a "$WIN_CLASS"

if [ $? -eq 1 ]; then
    $RUN_APP &
fi
