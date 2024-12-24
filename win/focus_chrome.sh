#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

# COMMAND="bash $HOME/scripts/chrome-fix-suspend &"
COMMAND="bash $HOME/scripts/chrome-dark &"
WINDOW_CLASS="google-chrome.Google-chrome"
#appTitle="Google Chrome"

#t=$(wmctrl -lp | grep "${appTitle}")

WMCTRL_SEARCH_OUTPUT_ALL=$(wmctrl -lx | grep --fixed-strings "${WINDOW_CLASS}")

echo "WMCTRL_SEARCH_OUTPUT_ALL:"
echo $WMCTRL_SEARCH_OUTPUT_ALL

WMCTRL_SEARCH_OUTPUT=$(echo "$WMCTRL_SEARCH_OUTPUT_ALL" | sed -n ${WINDOW_NUMBER}p)

echo "WMCTRL_SEARCH_OUTPUT:"
echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

echo "WMCTRL_NUMBER: $WMCTRL_NUMBER"

#if [ $? -eq 1 ]; then
if [[ -z "$WMCTRL_NUMBER" ]]; then
    #google-chrome &
    $COMMAND
    exit
fi

bash -c "$SCRIPT_DIR/focus-window-by-id.sh $WMCTRL_NUMBER"
