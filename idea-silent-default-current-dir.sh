#!/bin/bash

CMD="idea-silent.sh "

if [[ -z "$@" ]]; then
  $CMD .
else
  $CMD "$@"
fi
