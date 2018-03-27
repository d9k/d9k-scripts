#!/bin/bash

for usb in `cat /proc/acpi/wakeup | grep "USB\|UHC" | cut -f1`;
do
        state=`cat /proc/acpi/wakeup | grep $usb | cut -f3 | cut -d' ' -f1 | tr -d '*'`
        echo "device = $usb, state = $state"
        if [ "$state" == "enabled" ]
        then
            echo $usb > /proc/acpi/wakeup
        fi
done