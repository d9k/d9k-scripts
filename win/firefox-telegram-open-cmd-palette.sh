#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Because xdotool is VERY slow on non-english keyboard layouts
# Related: https://stackoverflow.com/questions/48038038/xdotool-type-takes-ages-and-causes-entire-desktop-to-freeze
$SCRIPT_DIR/../hw-keyboard-layout-force-en.sh

# xdotool keyup Super_L
sleep 0.1
xdotool key ctrl+alt+p
