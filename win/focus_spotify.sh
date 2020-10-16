#!/bin/bash

WINDOW_CLASS=Spotify
COMMAND="spotify &"


# selecting second window

# -x: + WIN CLASS
WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n 1p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
  $COMMAND
  exit
fi

# echo ${WMCTRL_NUMBER}

set -x
# -v: verbose
# -i: int value, not caption text
# -a: activate
wmctrl -v -i -a  ${WMCTRL_NUMBER}

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
