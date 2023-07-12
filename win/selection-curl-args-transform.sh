#!/bin/bash

DENO_SCRIPT="$HOME/cr/curl_args_transform/main.ts"

if [ ! -f "$DENO_SCRIPT" ]; then
  DENO_SCRIPT='https://deno.land/x/curl_args_transform/main.ts'
fi

sleep 0.2
xdotool keyup Control_L Control_R Shift_L Shift_R
xdotool sleep 0.2 key --clearmodifiers "Control_L+c"

CLIPBOARD=$(xsel -ob)

echo -e "$CLIPBOARD" | \
  /home/d9k/.deno/bin/deno run --allow-all --no-config "$DENO_SCRIPT" | \
  xclip -selection c

xdotool sleep 0.2 key --clearmodifiers "Control_L+v"
