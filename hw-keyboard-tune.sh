#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# xev
$SCRIPT_DIR/hw-keyboard-swap-caps-lock-esc.sh
# xmodmap $SCRIPT_DIR/cfg/keyboard/space-to-left-alt.Xmodmap
$SCRIPT_DIR/hw-keyboard-fix-repeat-rate.sh
