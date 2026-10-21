#!/bin/sh
xdotool getmouselocation --shell | grep "^X=" | grep --only-matching "[0-9]*"
