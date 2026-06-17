#!/bin/bash

function ask_continue {
  local ACTION_NAME=$1
  if [[ -z "${ACTION_NAME}" ]]; then
    ACTION_NAME="continue"
  fi

  # -s	        do not echo input coming from a terminal
  # -p          prompt	output the string PROMPT without a trailing newline before
  #       attempting to read
  # -r  	  	  do not allow backslashes to escape any characters
  # -n nchars	  return after reading NCHARS characters rather than waiting
  #    		for a newline,
  read -n 1 -r -p "Press \"y\" to ${ACTION_NAME}: " input

  # new line but with stderr, escaping capture output
  echo >&2

  if [ "$input" != "Y" ] && [ "$input" != "y" ] && [ "$input" != "д" ] && [ "$input" != "Д" ]; then
    exit
  fi
  echo 1
}

ask_continue "continue this script" > /dev/null

echo "You've chosen to continue"

SIMPLE_WAY_MODE=$(ask_continue "choose the simple way")

if [[ -n "$SIMPLE_WAY_MODE" ]]; then
   echo "You've chosen simple way"
else
   echo "You've chosen hard way"
fi
