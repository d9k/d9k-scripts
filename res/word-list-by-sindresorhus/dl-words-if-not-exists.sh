#!/bin/bash

# to current script directory
cd "$(dirname "$0")"

if [[ ! -f "words.txt" ]]; then
  ./dl-words.sh
fi
