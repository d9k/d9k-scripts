#!/bin/bash

INPUT=

if [ ! -t 0 ]; then
  INPUT=$(< /dev/stdin)
else
  INPUT="$@"
fi

# TODO problems with passing spaces in args!
#silent.sh textadept "$INPUT";

#export LD_PRELOAD=

textadept "$INPUT" 2>&1 &>/dev/null &
disown
