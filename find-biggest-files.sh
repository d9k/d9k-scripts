#!/bin/bash

# https://stackoverflow.com/questions/22598205/how-sort-find-result-by-file-sizes

# find . -type f -printf '%s\t%p\n' | sort -n | cut -f2-
find . -type f -printf '%k\t%p' | sort -n
