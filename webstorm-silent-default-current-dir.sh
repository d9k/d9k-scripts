#!/bin/bash

CMD="webstorm-silent.sh "

if [[ -z "$@" ]]; then
  $CMD .
else
  $CMD "$@"
fi
