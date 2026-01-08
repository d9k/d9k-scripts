#!/bin/bash

killall cinnamon

export DISPLAY=:0

# cinnamon --replace
set -x
cinnamon-launcher
