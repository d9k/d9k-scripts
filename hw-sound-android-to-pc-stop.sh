#!/bin/bash

# Script to restart sndcpy to minimize delay accumulation
#
# sndcpy - Forward android audio to pc:
# https://github.com/rom1v/sndcpy

# crontab:
# */15 * * * * /bin/bash /home/d9k/scripts/sndcpy-autorestart.sh

# Or no sound!
export XDG_RUNTIME_DIR="/run/user/1000"

PID=$(pgrep -f '\.\/sndcpy$')

if [ -z "$PID" ]; then
  echo not found sndcpy;
  exit
fi

kill -9 "$PID"
killall vlc
