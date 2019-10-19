#!/bin/bash

INPUT=

if [ ! -t 0 ]; then
  INPUT=$(< /dev/stdin)
else
  INPUT="$@"
fi

silent.sh textadept "$INPUT";
