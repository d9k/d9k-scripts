#!/bin/bash

WINDOW_ID="$1"
STREAM_OUTPUT='udp://127.0.0.1:2000'

if [[ -z "$WINDOW_ID" ]]; then
  echo "Error! Provide window id (use xwininfo or wmctrl -lx)"
  ( set -x; wmctrl -lx )
  exit
fi

echo -e "In OBS Studio add \"Media Source\", uncheck \"Local File\", copy \"$STREAM_OUTPUT\" value to Input field\n\n"

# https://ffmpeg.org/ffmpeg-devices.html#x11grab
# https://www.youtube.com/watch?v=eXbndLq5P7I
# https://trac.ffmpeg.org/wiki/StreamingGuide, see "Final working p2p client, with multicast"


# -probesize 3M \

set -x

ffmpeg \
  -re \
  -f x11grab \
  -framerate 30 \
  -window_id "$WINDOW_ID" \
  -i :0.0 \
  -f dshow \
  -vcodec libx264 \
  -pix_fmt yuv420p \
  -tune zerolatency \
  -preset ultrafast \
  -f mpegts \
  "$STREAM_OUTPUT"
#  -f rtsp \
#  -rtsp_transport tcp \
#  rtsp://localhost:8888/live.sdp


  # -f flv \
  # "rtmps://localhost/"
