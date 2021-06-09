#!/bin/bash

#lower => better priority

# Закомментировал, т. к. в некоторых случаях неподходящий под шаблон класс jetbrains-phpstorm-debug
#WINDOW_CLASS=jetbrains-phpstorm.jetbrains-phpstorm
#WINDOW_CLASS=jetbrains-phpstorm
WINDOW_CLASS=jetbrains-webstorm

WINDOW_NUMBER=3

# selecting second window

# -x: + WIN CLASS
WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n ${WINDOW_NUMBER}p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
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
