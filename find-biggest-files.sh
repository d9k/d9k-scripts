#!/bin/bash

# https://stackoverflow.com/questions/22598205/how-sort-find-result-by-file-sizes

# find . -type f -printf '%s\t%p\n' | sort -n | cut -f2-


MIN_SIZE_KB="$1"

if [[ -z "$MIN_SIZE_KB" ]]; then
  MIN_SIZE_KB=512
fi

find . -type f -size +"$MIN_SIZE_KB"k -printf '%k	%p\n' | sort -n
