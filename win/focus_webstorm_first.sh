#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#lower => better priority

# Закомментировал, т. к. в некоторых случаях неподходящий под шаблон класс jetbrains-phpstorm-debug
#WINDOW_CLASS=jetbrains-phpstorm.jetbrains-phpstorm
#WINDOW_CLASS=jetbrains-phpstorm
WINDOW_CLASS_WEBSTORM=jetbrains-webstorm
WINDOW_CLASS_IDEA=jetbrains-idea

WINDOW_NUMBER=1

# selecting second window

# -x: + WIN CLASS
# WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n ${WINDOW_NUMBER}p)

# echo $WMCTRL_SEARCH_OUTPUT

# WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

# if [[ -z "$WMCTRL_NUMBER" ]]; then
#   exit
# fi

# # echo ${WMCTRL_NUMBER}

# set -x
# # -v: verbose
# # -i: int value, not caption text
# # -a: activate
# wmctrl -v -i -a  ${WMCTRL_NUMBER}

# #if [ $? -eq 1 ]; then
# #  if [ "${ix}" -eq "0" ]; then
# #    echo 1
# #    #echo "Last one: starting NetBeans"
# #    #/bin/bash -c "source /home/d9k/.rvm/scripts/rvm; /home/d9k/netbeans-8.0/bin/netbeans" &
# #  fi
# #else
# #  echo "focusing \"${t}\""
# #  wmctrl -a "${titles[ix]}"
# #  break
# #  fi

${SCRIPT_DIR}/focus-window-by-class.sh --number "$WINDOW_NUMBER" "$WINDOW_CLASS_WEBSTORM"

if [[ "$?" != "0" ]]; then
  ${SCRIPT_DIR}/focus-window-by-class.sh --number "$WINDOW_NUMBER" "$WINDOW_CLASS_IDEA"
fi