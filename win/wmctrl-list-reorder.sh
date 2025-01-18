#!/bin/bash

# Content example: 
# 0x08600004
# 0x08400006
WMCTRL_CFG_ORDER="$HOME/.wmctrl-list-first-hex-ids"

if [ ! -f "$WMCTRL_CFG_ORDER" ]; then
  wmctrl -l "$@" 
  exit
fi

WMCTRL_LIST_LINES=$(wmctrl -l "$@")

while read WMCTRL_CFG_FIRST_IDS_LINE; do
  # echo "$WMCTRL_CFG_FIRST_IDS_LINE"
  WMCTRL_LIST_LINES_BEGIN=$(echo -e "$WMCTRL_LIST_LINES" | grep "$WMCTRL_CFG_FIRST_IDS_LINE")
  WMCTRL_LIST_LINES_END=$(echo -e "$WMCTRL_LIST_LINES" | grep -v "$WMCTRL_CFG_FIRST_IDS_LINE")

  if [[ -n "$WMCTRL_LIST_LINES_BEGIN" ]]; then
    WMCTRL_LIST_LINES_BEGIN="$WMCTRL_LIST_LINES_BEGIN\n"
  fi
  
  WMCTRL_LIST_LINES=$(echo -e "$WMCTRL_LIST_LINES_BEGIN$WMCTRL_LIST_LINES_END")
done < $WMCTRL_CFG_ORDER

echo "$WMCTRL_LIST_LINES"
