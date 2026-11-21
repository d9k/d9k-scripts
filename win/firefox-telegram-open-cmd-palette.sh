#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$SCRIPT_DIR/../hw-keyboard-layout-force-en.sh

# xdotool keyup Super_L
sleep 0.1
xdotool key ctrl+alt+p
