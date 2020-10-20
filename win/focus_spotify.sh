#!/bin/bash

WINDOW_CLASS=Spotify
#WINDOW_CLASS=Terminal
COMMAND="spotify &"

# -x: + WIN CLASS
WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n 1p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
  $COMMAND
  exit
fi

WMCTRL_NUMBER=$(printf "%d\n" ${WMCTRL_NUMBER})
echo WMCTRL_NUMBER: ${WMCTRL_NUMBER}


FOCUSED_WMCTRL_NUMBER=$(xdotool getwindowfocus)
echo FOCUSED_WMCTRL_NUMBER: ${FOCUSED_WMCTRL_NUMBER}

if [[ "$FOCUSED_WMCTRL_NUMBER" == "$WMCTRL_NUMBER" ]]; then
  ALREADY_FOCUSED=1
fi


if [ -n "$ALREADY_FOCUSED" ]; then
  set -x
  #wmctrl -b toggle,shaded -a ${WMCTRL_NUMBER}
  xdotool windowminimize ${WMCTRL_NUMBER}
else
  set -x
  # -v: verbose
  # -i: int value, not caption text
  # -a: activate
  wmctrl -v -i -a  ${WMCTRL_NUMBER}
fi
#if [ $? -eq 1 ]; then
#  if [ "${ix}" -eq "0" ]; then
#    echo 1
#    #echo "Last one: starting NetBeans"
#    #/bin/bash -c "source /home/d9k/.rvm/scripts/rvm; /home/d9k/netbeans-8.0/bin/netbeans" &
#  fi
#else
#  echo "focusing \"${t}\""
#  wmctrl -a "${titles[ix]}"
#  break
#  fi
