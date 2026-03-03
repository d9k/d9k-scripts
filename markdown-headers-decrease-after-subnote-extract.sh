#!/bin/bash

function echoerr {
  printf "%s\n" "$*" >&2;
}

FILE_NAME="$1"

if [[ -z "$FILE_NAME" ]]; then
  echoerr "Error: file name was not provided! Exitting..."
  exit 1
fi

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
  read -n 1 -r -p "Press \"y\" to ${action_name}: " input

  # new line but with stderr, escaping capture output
  echo >&2

  if [ "$input" != "Y" ] && [ "$input" != "y" ] && [ "$input" != "д" ] && [ "$input" != "Д" ]; then
    exit
  fi
  echo 1
}

printf "\n# Current headers state\n\n"
 
( set -x; rg "^#" "$FILE_NAME" )

printf "\n# After planned changes\n\n"

( set -x; rg "^#" --replace "" "$FILE_NAME" )

printf "\n"

if [[ "$(ask_continue 'apply replacement')" != "1" ]]; then
  echoerr "You choosed to cancel the replacement. Exitting"
  exit;
fi

( set -x; wrg "^#" --replace "" "$FILE_NAME" )

# TODO git commit with default message: "$FILE_NAME": fix headers level after subnote extraction
