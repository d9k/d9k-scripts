#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xdotool sleep 0.05 key Escape

sleep 0.2
$SCRIPT_DIR/telegram-copy-at-mouse-cursor.sh

# CLIPBOARD="$(xclip -selection clipboard -o | tr '\n' ' ')"
FRAGMENT_MAX_CHARS=120

CLIPBOARD="$(xclip -selection clipboard -o)"
CLIPBOARD_CHARS="$(printf "%s" "$CLIPBOARD" | wc -m)"
# perl substr cuts by UTF-8 chars; head -c cuts bytes and breaks multibyte chars, yad rejects invalid UTF-8
# With `head -c` there was an error: `Unable to parse command line: Invalid byte sequence in conversion input`
FRAGMENT="$(printf "%s" "$CLIPBOARD" | perl -CSD -e 'local $/; $_ = <STDIN>; print substr($_, 0, $ARGV[0])' "$FRAGMENT_MAX_CHARS")"
if [ "$CLIPBOARD_CHARS" -gt "$FRAGMENT_MAX_CHARS" ]; then
  FRAGMENT="$FRAGMENT..."
fi

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
  --title="Did it copy correct?" \
  --text="Check the fragment:\n\n$FRAGMENT" \
  --button="gtk-yes:0" \
  --button="gtk-no:1"
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

