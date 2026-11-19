#!/bin/bash

# TODO Find better solution. THIS IS UGLY HACK!
#
# Press Escape in a way that does not toggle the keyboard layout.
#
# In cfg/keyboard/swap-caps-lock-esc.Xmodmap the Escape and Caps_Lock keys are
# swapped, so keycode 66 (the physical Escape key) is mapped to Caps_Lock
# (ISO_Next_Group/Caps_Lock). Caps_Lock is also the layout switcher
# (setxkbmap option grp:caps_toggle), so pressing "Escape" may switch the
# keyboard layout instead of just closing a dialog.
#
# Workaround: detect the swap, temporarily revert it
# (cfg/keyboard/swap-caps-lock-esc-revert.Xmodmap, where the real Escape
# keysym sits on the real Escape keycode 9), press Escape, then restore
# the swap. If the swap is not active, just press Escape.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SWAP_FILE="$SCRIPT_DIR/../cfg/keyboard/swap-caps-lock-esc.Xmodmap"
REVERT_FILE="$SCRIPT_DIR/../cfg/keyboard/swap-caps-lock-esc-revert.Xmodmap"

# keycode 9 is the physical Escape key
if ! xmodmap -pke | grep -E '^keycode + 9' | grep -q 'Caps_Lock'; then
  xdotool key Escape
  exit 0
fi

restore_swap() {
  xmodmap "$SWAP_FILE"
}

# Always restore the swap, even on Ctrl+C or an error in the middle
trap restore_swap EXIT

xmodmap "$REVERT_FILE"

xdotool key Escape
