#!/bin/bash

if [[ "$#" -lt 1 ]]; then
  echo "argument needed"
  exit
fi

# TODO problems with passing spaces in args!
$@ 2>&1 &>/dev/null &
disown
