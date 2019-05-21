#!/bin/bash

#pattern_quote() {
#    sed 's/[]\.|${}?+*^-]/\\&/g' <<< "$*"
#}

#name="xed.Xed"

#see http://stackoverflow.com/a/11856117/1760643
#grep_pattern=$(pattern_quote "${name}")

# -x: with window class

#

#t=$(wmctrl -lx | grep "${grep_pattern}")
#if [ $? -eq 1 ]; then
#    xed &
#else
#    wmctrl -a "${name}"
#fi

WIN_CLASS="xed.Xed"
RUN_APP="xed"

wmctrl -x -a "$WIN_CLASS"

if [ $? -eq 1 ]; then
    $RUN_APP &
fi
