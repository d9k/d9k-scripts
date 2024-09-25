#!/bin/bash


function echo_and_eval() {
  echo "> $@"
  EVAL_RESULT=$(eval "$@")
}

CMD="rename-ask \"s/[:：]+//g\""

if [ "$#" -lt 1 ]; then
  echo "> $CMD *"
  eval "$CMD *"
else
  QUOTED_ARGS=$(printf ' %q' "$@")
  CMD="$CMD $QUOTED_ARGS"
  echo "> $CMD"
  eval "$CMD"
fi

