#!/bin/bash

WINDOW_ID="$1"
STREAM_OUTPUT='udp://127.0.0.1:2000'
MICROPHONE="default"
QUEUE_SIZE=128

if [[ -z "$WINDOW_ID" ]]; then
  echo "Error! Provide window id (use xwininfo or wmctrl -lx)"
  ( set -x; wmctrl -lx )
  exit
fi

echo -e "In OBS Studio add \"Media Source\", uncheck \"Local File\", copy \"$STREAM_OUTPUT\" value to Input field\n\n"

# https://ffmpeg.org/ffmpeg-devices.html#x11grab
# https://www.youtube.com/watch?v=eXbndLq5P7I
# https://trac.ffmpeg.org/wiki/StreamingGuide, see "Final working p2p client, with multicast"

# https://trac.ffmpeg.org/wiki/Capture/PulseAudio
# /bin/ffmpeg -f pulse -i default out.wav

# -probesize 3M \

set -x


  # -f alsa -i plughw:1 \
  #
  # -i audio="$MICROPHONE" \
  #
  #
  # -f pulse -i default \
  #
  # -copyts \

/bin/ffmpeg \
  -re \
  -f x11grab \
  -thread_queue_size $QUEUE_SIZE \
  -framerate 30 \
  -window_id "$WINDOW_ID" \
  -i :0.0 \
  -f pulse \
  -thread_queue_size $QUEUE_SIZE \
  -i "$MICROPHONE" \
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
