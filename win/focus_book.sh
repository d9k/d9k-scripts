#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Посмотреть список классов открытых окон:
# wmctrl -lx

# (чем выше, тем приоритетнее)
WINDOW_CLASSES=(
 "Zathura"
 "Okular"
 "xreader"
)

for (( ix=0 ; ix<${#WINDOW_CLASSES[@]} ; ix++ )); do
  WINDOW_CLASS="${WINDOW_CLASSES[ix]}"
	echo "checking \"${WINDOW_CLASS}\":"
  WINDOW_NUMBER=1

  ${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS"

  if [ $? == 0 ]; then
    echo "Found. Exitting"
    exit;
  fi
done

"$SCRIPT_DIR/../pdf-history.sh"
