#!/bin/bash

name="Light Table"

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    LightTable &
else
    wmctrl -a "${name}"
fi
