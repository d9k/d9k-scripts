#!/bin/bash

CMD="nemo-silent.sh"

if [[ -z "$@" ]]; then
  $CMD .
else
  $CMD "$@"
fi
