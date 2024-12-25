#!/bin/bash

# Content example: 
# 0x08600004
# 0x08400006
WMCTRL_CFG_ORDER="$HOME/.wmctrl-list-first-hex-ids"

if [ ! -f "$WMCTRL_CFG_ORDER" ]; then
  wmctrl -l "$@" 
  exit
fi

WMCTRL_CFG_ORDER_CONTENT_REVERSE=$(tac "$WMCTRL_CFG_ORDER")

if [[ -z "$WMCTRL_CFG_ORDER_CONTENT_REVERSE" ]]; then
  wmctrl -l "$@" 
  exit
fi

ORDER_REGEX=$(echo -e "$WMCTRL_CFG_ORDER_CONTENT_REVERSE" | awk 'ORS="\\|"' 2>/dev/null | head -c -2)

RESULT_BEGIN=$(wmctrl -l "$@" | grep "$ORDER_REGEX")
RESULT_END=$(wmctrl -l "$@" | grep -v "$ORDER_REGEX")

echo -e "$RESULT_BEGIN"
echo -e "$RESULT_END"
