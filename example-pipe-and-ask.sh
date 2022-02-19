#!/bin/bash

function ask_continue { action_name=$1
  if [[ -z "${action_name}" ]]; then
    action_name="continue"
  fi

  # -s	        do not echo input coming from a terminal
  # -p          prompt	output the string PROMPT without a trailing newline before
  #       attempting to read
  # -r  	  	  do not allow backslashes to escape any characters
  # -n nchars	  return after reading NCHARS characters rather than waiting
  #    		for a newline,
  read -n 1 -r -p "Press \"y\" to ${action_name}: " input < /dev/tty

  # new line but with stderr, escaping capture output
  echo >&2

  if [ "$input" != "Y" ] && [ "$input" != "y" ]; then
    exit
  fi
  echo 1
}

PIPE_INPUT=$(< /dev/stdin)

echo "$PIPE_INPUT"


if [[ -z $(ask_continue "running script") ]]; then
  exit;
fi
echo "Continued"
