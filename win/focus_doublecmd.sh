#!/bin/bash

name="Double Commander"

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    doublecmd &
else
    wmctrl -a "${name}"
fi
