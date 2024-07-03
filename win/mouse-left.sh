#/bin/sh
#SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo $SCRIPT_DIR

MOUSE_SPEED_PX=30

xdotool mousemove_relative -- -$MOUSE_SPEED_PX 0
