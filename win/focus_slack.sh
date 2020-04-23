#!/bin/bash

app="Slack"

t=$(wmctrl -lp | grep ${app})
if [ $? -eq 1 ]; then
    /snap/bin/slack &
else
    wmctrl -a ${app}
fi
