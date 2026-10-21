#!/bin/bash
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
MINIMAL_DISTANCE_PX=50
MAX_WAIT_MS=8000
DELAY_PER_CYCLE_RUN_MS=50

# Did an ugly hack: send keystrokes to the warpd daemon, detect mouse movement, then click. See:
# [Slow --oneshot start from CLI | issue #346 | warpd](https://github.com/rvaiya/warpd/issues/346), 2026.10.22

awk_calc_float() { 
  /usr/bin/awk "BEGIN{ printf \"%.2f\n\", $* }"; 
}

awk_calc_decimal() { 
  /usr/bin/awk "BEGIN{ printf \"%d\n\", $* }"; 
}

awk_decimal_abs() {
  /usr/bin/awk '
    function abs(v) {
        return (v < 0) ? -v : v
    }
    BEGIN{
        print abs('$*')
    }'
}

# echo $(awk_decimal_abs -4)
# echo $(awk_decimal_abs 5)

DELAY_PER_CYCLE_RUN_S=$(awk_calc_float $DELAY_PER_CYCLE_RUN_MS/1000)

set -x
echo $DELAY_PER_CYCLE_RUN_MS
set +x

LAST_MOUSE_X=$($SCRIPT_DIR/get-mouse-x.sh)
LAST_MOUSE_Y=$($SCRIPT_DIR/get-mouse-y.sh)

xdotool keyup Shift
xdotool keyup Super
# xdotool key --clearmodifiers Super+o &
xdotool key Super+o &

TOTAL_WAIT_MS=0

while [ $TOTAL_WAIT_MS -lt $MAX_WAIT_MS ]; do
    sleep $DELAY_PER_CYCLE_RUN_S
    TOTAL_WAIT_MS=$(($TOTAL_WAIT_MS+$DELAY_PER_CYCLE_RUN_MS))
    echo "$TOTAL_WAIT_MS"
    NEW_MOUSE_X=$($SCRIPT_DIR/get-mouse-x.sh)
    NEW_MOUSE_Y=$($SCRIPT_DIR/get-mouse-y.sh)
    MOUSE_DELTA_X=$(($NEW_MOUSE_X-$LAST_MOUSE_X))
    MOUSE_DELTA_Y=$(($NEW_MOUSE_Y-$LAST_MOUSE_Y))
    MOUSE_DELTA_X_ABS=$(awk_decimal_abs $MOUSE_DELTA_X)
    MOUSE_DELTA_Y_ABS=$(awk_decimal_abs $MOUSE_DELTA_Y)
    MOUSE_DISTANCE_PX=$(awk_calc_decimal "sqrt($MOUSE_DELTA_X_ABS^2+$MOUSE_DELTA_Y_ABS^2)")
    echo "$MOUSE_DELTA_X $MOUSE_DELTA_Y $MOUSE_DELTA_X_ABS $MOUSE_DELTA_Y_ABS $MOUSE_DISTANCE_PX"

    if [[ $MOUSE_DISTANCE_PX -ge $MINIMAL_DISTANCE_PX ]]; then
      echo "Done! Mouse traveled $MOUSE_DISTANCE_PX px"
      $SCRIPT_DIR/mouse-click-left.sh
      exit
    fi

    LAST_MOUSE_X=$NEW_MOUSE_X
    LAST_MOUSE_Y=$NEW_MOUSE_Y
done
