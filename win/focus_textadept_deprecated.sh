#!/bin/bash

pattern_quote() {
#    sed 's/[]\.|$(){}?+*^-]/\\&/g' <<< "$*"
    sed 's/[]\.|${}?+*^-]/\\&/g' <<< "$*"
}

name="Textadept ("

#see http://stackoverflow.com/a/11856117/1760643
grep_pattern=$(pattern_quote "${name}")
t=$(wmctrl -lp | grep "${grep_pattern}")
if [ $? -eq 1 ]; then
    textadept &
else
    wmctrl -a "${name}"
fi
