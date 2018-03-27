#!/bin/bash

desktop_env=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')

    name="System Monitor"
if [ "$desktop_env" == "kde" ]; then
    command="ksysguard"
elif [ "$desktop_env" == "gnome" ]; then
    command="gnome-system-monitor"
else
   echo "error! desktop environment \"${desktop_env}\" is undefined"
fi

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    $command &
else
    wmctrl -a "${name}"
fi
