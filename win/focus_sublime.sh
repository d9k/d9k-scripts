#!/bin/bash

name="Sublime Text 2"

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    sublime-text &
else
    wmctrl -a "${name}"
fi
