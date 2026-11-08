#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

FILE_SELECTING_PATH="$HOME/.mouse-selecting-with-keyboard"
RELEASE_TIMEOUT_S=8

# overlay-window-border-current-display.sh configuration
export BORDER_COLOR="0x0090A0"
export BORDER_TIMEOUT_MS=$(( $RELEASE_TIMEOUT_S * 1000))

function mouse_button_release_with_message {
  rm "$FILE_SELECTING_PATH"
  $SCRIPT_DIR/mouse-release-left-button.sh
  pkill -f "overlay-window-border.py"
  if [ -n "$1" ]; then
    notify-send -t 3000 "$@"
  fi
}

if [ -f "$FILE_SELECTING_PATH" ]; then 
  mouse_button_release_with_message "Mouse button released. Run command again to select"
  exit
fi

# $SCRIPT_DIR/mouse-switch-display.sh
# $SCRIPT_DIR/mouse-warp-point.sh
notify-send -t 3000 "Choose end of selection with warpd"

# xte slightly faster than xdotool
# `sudo apt install xautomation` required for xte!
xte 'keyup Super_L'
xte 'keyup Shift_L'
$SCRIPT_DIR/mouse-hold-left-button.sh

touch "$FILE_SELECTING_PATH"

# warpd --screen --hint2 --oneshot

$SCRIPT_DIR/warpd-cfg-set-hint-color.sh "#00E5FF"

$SCRIPT_DIR/mouse-move-from-warpd-daemon.sh
EXIT_CODE=$?

if [ $EXIT_CODE -ne 100 ]; then
  mouse_button_release_with_message
  exit
fi

# reset hint color
$SCRIPT_DIR/warpd-cfg-set-hint-color.sh

notify-send -t 3000 "Run again to release mouse button or it will be release after ${RELEASE_TIMEOUT_S} seconds."
# $SCRIPT_DIR/overlay-window-border-current-display.sh

sleep $RELEASE_TIMEOUT_S

if [ -f "$FILE_SELECTING_PATH" ]; then 
  # $SCRIPT_DIR/mouse-release-left-button.sh
  # rm "$FILE_SELECTING_PATH" 
  # notify-send -t 3500 "Mouse button released by timeout. Run command again to select"
  mouse_button_release_with_message "Mouse button released by timeout. Run command again to select"
fi
