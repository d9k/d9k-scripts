#!/bin/bash

sleep 0.5
xdotool keyup Control_L Control_R Shift_L Shift_R

xdotool sleep 0.2 click 3
xdotool sleep 0.6 key --clearmodifiers Down
xdotool sleep 0.1 key --repeat 3 --delay 0.03 --clearmodifiers Down
xdotool sleep 0.1 key --clearmodifiers Return
xdotool sleep 0.2 key --repeat 8 --delay 0.03 --clearmodifiers Down
xdotool sleep 0.5 key --clearmodifiers Return

CLIPBOARD=$(xsel -ob)
# AUTH_TOKEN=$(grep "\-H 'Authorization:" | awk -v FS="('Authorization: Bearer |')" '{print $2}')
#AUTH_TOKEN=$(\
  #echo -e "$CLIPBOARD" | \
  #grep "\-H 'Authorization:" | \
  #awk -v FS="('Authorization: Bearer |')" '{print $2}'\
#)

DENO_SCRIPT="$HOME/cr/curl_args_transform/main.ts"

if [ ! -f "$DENO_SCRIPT" ]; then
  DENO_SCRIPT='https://deno.land/x/curl_args_transform/main.ts'
fi

echo -e "$CLIPBOARD" | \
  /home/d9k/.deno/bin/deno run --allow-all --no-config "$DENO_SCRIPT" | \
  xclip -selection c

  #$HOME/.deno/bin/curl_args_transform | \
# CLIPBOARD=$(xsel -ob)
# $(echo -e "$CLIPBOARD")
