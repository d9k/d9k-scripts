#!/bin/bash

t=$(wmctrl -lp | grep "Mozilla Firefox")
if [ $? -eq 1 ]; then
    firefox &
else
    wmctrl -a "Mozilla Firefox"
fi
