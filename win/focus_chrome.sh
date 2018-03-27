#!/bin/bash

appTitle="Google Chrome"

t=$(wmctrl -lp | grep "${appTitle}")
if [ $? -eq 1 ]; then
    google-chrome &
else
    wmctrl -a "${appTitle}"
fi
