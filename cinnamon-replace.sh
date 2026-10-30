#!/bin/bash

killall warpd

sleep 1

killall cinnamon

# TODO all `cinnamon --replace` processes must be kllled or lock screen wouldn't work!
sleep 2

export DISPLAY=:0

# cinnamon --replace
set -x
cinnamon-launcher
