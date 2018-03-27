#!/bin/bash

if [[ "$#" -lt 1 ]]; then
  echo "argument needed"
  exit
fi

$@ 2>&1 &>/dev/null &
disown