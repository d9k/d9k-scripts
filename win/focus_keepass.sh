#!/bin/bash

t=$(wmctrl -lp | grep "\- KeePassX")
if [ $? -eq 1 ]; then
    keepassx &
else
    wmctrl -a "- KeePassX"
fi
