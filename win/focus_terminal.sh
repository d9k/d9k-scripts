#!/bin/bash

name="Terminal"

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    xfce4-terminal &
#   doesn't work:
#    xfce4-terminal -H --command='zsh -c ". ~/.aliases; ~/scripts/tmx-new-or-resume"' &

else
    wmctrl -a "${name}"
fi
