#!/bin/bash

# Посмотреть список классов открытых окон:
# wmctrl -lx
# (чем выше, тем приоритетнее)
WINDOW_CLASSES=(
  "jetbrains-webstorm"
  "jetbrains-idea"
  "DBeaver"
)

for (( ix=0 ; ix<${#WINDOW_CLASSES[@]} ; ix++ )); do
  WINDOW_CLASS="${WINDOW_CLASSES[ix]}"
	echo "checking \"${WINDOW_CLASS}\":"
  WINDOW_NUMBER=1

  # wmctrl: -x: output WIN CLASS too
  WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n ${WINDOW_NUMBER}p)

  echo $WMCTRL_SEARCH_OUTPUT

  WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

  if [[ -n "$WMCTRL_NUMBER" ]]; then
    echo "Focusing ${WMCTRL_NUMBER}"

    # wmctrl:
    # -a: activate
    # -i: int value, not caption text
    # -v: verbose
    ( set -x; wmctrl -v -i -a  ${WMCTRL_NUMBER} )
    exit
  fi
done
