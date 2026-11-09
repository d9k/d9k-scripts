#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xdotool sleep 0.05 key Escape

sleep 0.2
$SCRIPT_DIR/telegram-copy-at-mouse-cursor.sh

# CLIPBOARD="$(xclip -selection clipboard -o | tr '\n' ' ')"
CLIPBOARD="$(xclip -selection clipboard -o)"
CLIPBOARD_BYTES="$(printf "%s" "$CLIPBOARD" | wc -c)"
FRAGMENT="$(printf "%s" "$CLIPBOARD" | head -c 320)"
if [ "$CLIPBOARD_BYTES" -gt 120 ]; then
  FRAGMENT="$FRAGMENT..."
fi

eval "$(xdotool getmouselocation --shell)"

yad \
  --question \
  --no-markup \
  --on-top \
  --center \
  --justify=center \
  --align=center \
  --margins=20 \
  --wrap \
  --title="Did it copy correct?" \
  --text="Check the fragment:\n\n$FRAGMENT"
ANSWER_CODE=$?

if [ $ANSWER_CODE -ne 0 ]; then
  exit 100
fi

xdotool mousemove $X $Y

sleep 0.3
$SCRIPT_DIR/telegram-delete-at-mouse-cursor.sh
sleep 0.3
# --clearmodifiers
xdotool sleep 0.5 key "Control_L+v"
sleep 0.2
xdotool sleep 0.5 key "Return"

