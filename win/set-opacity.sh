#!/bin/bash

# https://10pm.ca/script-to-set-window-opacity-in-linux-mint-cinnamon/

# set-opacity.sh OPACITY_LEVEL [WINDOW_CLASS]
# WINDOW_CLASS - current window if none

# set-opacity.sh firefox 70

NEW_OPACITY_PERCENT="$1"
WINDOW_CLASS="$2"

if [ -z "$NEW_OPACITY_PERCENT" ]; then
	echo "Need opacity level [0-100]"
	exit 1
fi

if [ -z "$WINDOW_CLASS" ]; then
	#echo "Need window name (and optional opacity)"
	#exit 1
  WINDOWID=$(xdotool getwindowfocus)
else
  WINDOWID=$(wmctrl -lx | grep -i "$WINDOW_CLASS" | cut -d" " -f1)

  # -x: + WIN CLASS
  #WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n ${WINDOW_NUMBER}p)
fi

# https://stackoverflow.com/a/34545932
ceil_div() {
    local num=${1:-0}
    local div=${2:-1}
    if ! ((div)); then
        return 1
    fi
    if ((num >= 0)); then
        echo $(( (num + div - 1) / div ))
    else
        echo $(( -(-num + div - 1) / div ))
    fi
}

if [ -z "$WINDOWID" ]; then
	echo "Title not found $1"

  echo
  echo "Available windows:"
  wmctrl -lx
	exit 1
fi

echo "WINDOWID: $WINDOWID"

CURRENT_OPACITY=$(\
  xprop \
  -id "$WINDOWID" \
  | grep _NET_WM_WINDOW_OPACITY \
  | tr -dc '0-9' \
)

if [[ -z "$CURRENT_OPACITY" ]]; then
  CURRENT_OPACITY=$((0xffffffff * 1))
fi

CURRENT_OPACITY_PERCENT="$(ceil_div $((CURRENT_OPACITY * 100)) 0xffffffff)"

NEW_OPACITY="$((0xffffffff * NEW_OPACITY_PERCENT / 100))"
NEW_OPACITY_HEX="$(printf 0x%x $NEW_OPACITY)"

echo "CURRENT_OPACITY: $CURRENT_OPACITY"
echo "CURRENT_OPACITY_PERCENT: $CURRENT_OPACITY_PERCENT"
echo "NEW_OPACITY: $NEW_OPACITY"
echo "NEW_OPACITY_HEX: $NEW_OPACITY_HEX"

xprop \
  -id "$WINDOWID" \
  -f _NET_WM_WINDOW_OPACITY 32c \
  -set _NET_WM_WINDOW_OPACITY "${NEW_OPACITY_HEX}"
