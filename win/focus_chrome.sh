#!/bin/bash

appTitle="Google Chrome"

t=$(wmctrl -lp | grep "${appTitle}")
if [ $? -eq 1 ]; then
    #google-chrome &
    bash $HOME/scripts/chrome-fix-suspend &
else
    wmctrl -a "${appTitle}"
fi
