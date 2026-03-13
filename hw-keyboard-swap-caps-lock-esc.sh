#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# hw-keyboard-fix-repeat-rate.sh

# https://www.linux.org.ru/forum/admin/13547364
xmodmap $SCRIPT_DIR/cfg/keyboard/swap-caps-lock-esc.Xmodmap
