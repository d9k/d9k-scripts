#!/bin/bash

WMCTRL_CFG_ORDER="$HOME/.wmctrl-list-first-hex-ids"

FOCUSED_WINDOW_ID_DEC=$(xdotool getwindowfocus)
FOCUSED_WINDOW_ID_HEX=$(printf "0x%08x\n" $FOCUSED_WINDOW_ID_DEC)

if [ ! -f "$WMCTRL_CFG_ORDER" ]; then
  touch "$WMCTRL_CFG_ORDER"
fi

MAX_LINES=10

WMCTRL_CFG_ORDER_CONTENTS=$(cat "$WMCTRL_CFG_ORDER" | tail -n "$MAX_LINES")

echo "$WMCTRL_CFG_ORDER_CONTENTS" > "$WMCTRL_CFG_ORDER"
echo "$FOCUSED_WINDOW_ID_HEX" >> "$WMCTRL_CFG_ORDER"

WMCTRL_INFO=$(wmctrl -lx | grep "$FOCUSED_WINDOW_ID_HEX")

echo "$WMCTRL_INFO"

notify-send "Bringing to front window:" "$WMCTRL_INFO"

cat "$WMCTRL_CFG_ORDER"
