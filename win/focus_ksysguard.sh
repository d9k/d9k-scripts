#!/bin/bash

name="System Monitor"

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    ksysguard &
else
    wmctrl -a "${name}"
fi
