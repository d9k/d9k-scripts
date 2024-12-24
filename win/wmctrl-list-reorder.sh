#!/bin/bash

# Content example: 
# 0x08600004\|0x08400006
WMCTRL_CFG_ORDER="$HOME/.wmctrl-list-first-regex"

if [ ! -f "$WMCTRL_CFG_ORDER" ]; then
  wmctrl -l "$@" 
  exit
fi

CFG_ORDER=$(cat "$WMCTRL_CFG_ORDER")

if [[ -z "$CFG_ORDER" ]]; then
  wmctrl -l "$@" 
  exit
fi

RESULT_BEGIN=$(wmctrl -l "$@" | grep "$CFG_ORDER")
RESULT_END=$(wmctrl -l "$@" | grep -v "$CFG_ORDER")

echo -e "$RESULT_BEGIN"
echo -e "$RESULT_END"
