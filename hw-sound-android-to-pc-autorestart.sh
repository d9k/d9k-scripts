#!/bin/bash

# Script to restart sndcpy to minimize delay accumulation
#
# sndcpy - Forward android audio to pc:
# https://github.com/rom1v/sndcpy

# crontab:
# */15 * * * * /bin/bash /home/d9k/scripts/hw-sound-android-to-pc-autorestart.sh

# Or no sound!
export XDG_RUNTIME_DIR="/run/user/1000"

PID=$(pgrep -f '\.\/sndcpy$')

if [ -z "$PID" ]; then
  echo not found sndcpy;
  exit
fi

kill -9 "$PID"
killall vlc

sleep 1

cd /home/d9k/soft/sndcopy
#/usr/bin/bash ./sndcpy >> /var/log/sndcpy.log &
/usr/bin/bash ./sndcpy >> /var/log/sndcpy.log 2>&1 &
