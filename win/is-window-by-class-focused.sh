#!/bin/bash

# check with `wmctrl -lx`
WINDOW_CLASS="$1"
SPECIFICALLY_WINDOW_TITLE="$2"

if [[ -z "$WINDOW_CLASS" ]]; then
  >&2 echo "Error: WINDOW_CLASS not set"
  >&2 echo "# Available classes:"
  >&2 wmctrl -lx
  exit 2
fi

#wmctrl -lx | grep ${WINDOW_CLASS}

FOCUSED_WMCTRL_NUMBER=$(xdotool getwindowfocus)
#echo FOCUSED_WMCTRL_NUMBER: ${FOCUSED_WMCTRL_NUMBER}

# -x: + WIN CLASS

WMCTRL_ROWS_BY_WINDOWS_CLASS=$(\
  wmctrl -lx | \
  grep "$WINDOW_CLASS" \
)


if [[ -n "SPECIFICALLY_WINDOW_TITLE" ]]; then
  WMCTRL_ROWS_BY_WINDOWS_CLASS=$(\
    echo "$WMCTRL_ROWS_BY_WINDOWS_CLASS" | \
    grep "$SPECIFICALLY_WINDOW_TITLE"
  )
else
  WMCTRL_ROWS_BY_WINDOWS_TITLE="$WMCTRL_ROWS_BY_WINDOWS_CLASS"
fi

WMCTRL_NUMBERS_BY_WINDOWS_CLASS=$(\
  echo "$WMCTRL_ROWS_BY_WINDOWS_CLASS" | \
  # first column:
  awk '{print $1;}' | \
  # to decimal: \
  xargs -n 1 printf "%d\n"
)

#echo "$WMCTRL_NUMBERS_BY_WINDOWS_CLASS"

  #\
  #grep "$FOCUSED_WMCTRL_NUMBER"


# whole number match: \
echo "$WMCTRL_NUMBERS_BY_WINDOWS_CLASS" | grep --word-regexp  "$FOCUSED_WMCTRL_NUMBER"
