#!/bin/sh
xdotool getmouselocation --shell | grep "^Y=" | grep --only-matching "[0-9]*"
