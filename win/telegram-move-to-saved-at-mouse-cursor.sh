#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$SCRIPT_DIR/mouse-click-right.sh

xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Up
xdotool sleep 0.05 key Return
sleep 0.16
xdotool sleep 0.05 type '/save/'
sleep 1.0
xdotool sleep 0.05 key Down
sleep 0.2
xdotool sleep 0.05 key Return
sleep 1.0
xdotool sleep 0.05 key Return
sleep 0.2
xdotool sleep 0.05 key Return

sleep 1.5

xdotool sleep 0.2 key Escape
# $SCRIPT_DIR/telegram-copy-at-mouse-cursor.sh

eval "$(xdotool getmouselocation --shell)"

# yad --question pre-selects the No button, so Enter would cancel the move;
# explicit buttons make the Enter key activate the first declared one, therefore Yes comes first
yad \
  --no-markup \
  --on-top \
  --justify=center \
  --align=center \
  --margins=20 \
  --wrap \
  --mouse \
  --title="Did it moved correct?" \
  --text="Proceed to remove original record" \
  --button="gtk-yes:0" \
  --button="gtk-no:1"

YAD_ANSWER_CODE=$?

if [ $YAD_ANSWER_CODE -ne 0 ]; then
  exit 100
fi

xdotool mousemove $X $Y

sleep 0.3
$SCRIPT_DIR/telegram-delete-at-mouse-cursor.sh

