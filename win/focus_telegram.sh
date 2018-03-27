#!/bin/bash

app="Telegram"

t=$(wmctrl -lp | grep ${app})
if [ $? -eq 1 ]; then
    ~/soft/Telegram/Telegram &
else
    wmctrl -a ${app}
fi
