#!/bin/bash

xdotool sleep 0.2 click 3
xdotool sleep 0.4 key --clearmodifiers Down
xdotool sleep 0.1 key --repeat 3 --delay 0.03 --clearmodifiers Down
xdotool sleep 0.1 key --clearmodifiers Return
xdotool sleep 0.2 key --repeat 8 --delay 0.03 --clearmodifiers Down
xdotool sleep 0.1 key --clearmodifiers Return

CLIPBOARD=$(xsel -ob)
# AUTH_TOKEN=$(grep "\-H 'Authorization:" | awk -v FS="('Authorization: Bearer |')" '{print $2}')
AUTH_TOKEN=$(\
  echo -e "$CLIPBOARD" | \
  grep "\-H 'Authorization:" | \
  awk -v FS="('Authorization: Bearer |')" '{print $2}'\
)

echo -e "AUTH_TOKEN=\"$AUTH_TOKEN\"" | xclip -selection c

# CLIPBOARD=$(xsel -ob)
# $(echo -e "$CLIPBOARD")

