#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/displays.inc.sh"

MOUSE_DISPLAY_NUM="$(get_mouse_display_num)"
MOUSE_POSITION_PATH="$HOME/.mouse-position-switch-display${MOUSE_DISPLAY_NUM}.json"

export BORDER_COLOR="0x0004710"
export BORDER_WIDTH="8"
export BORDER_TIMEOUT_MS=700

case "$MOUSE_DISPLAY_NUM" in
  1)
    TARGET_DISPLAY_NUM=2
    TARGET_X="$DISPLAY2_MX"
    TARGET_Y="$DISPLAY2_MY"
    ;;
  2)
    TARGET_DISPLAY_NUM=1
    TARGET_X="$DISPLAY1_MX"
    TARGET_Y="$DISPLAY1_MY"
    ;;
esac

TARGET_POSITION_PATH="$HOME/.mouse-position-switch-display${TARGET_DISPLAY_NUM}.json"

# save the position being left on the current display, so a later switch back can restore it
eval "$(xdotool getmouselocation --shell)"

jq --compact-output --null-input \
  --argjson x "$X" \
  --argjson y "$Y" \
  '{x: $x, y: $y}' > "$MOUSE_POSITION_PATH"

# the display center is used only while the target display has no saved position yet
if [[ -s "$TARGET_POSITION_PATH" ]]; then
  TARGET_X="$(jq --raw-output '.x' "$TARGET_POSITION_PATH")"
  TARGET_Y="$(jq --raw-output '.y' "$TARGET_POSITION_PATH")"
fi

xdotool mousemove "$TARGET_X" "$TARGET_Y"


$SCRIPT_DIR/overlay-window-border-current-display.sh
