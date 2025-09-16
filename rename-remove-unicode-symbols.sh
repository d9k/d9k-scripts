#!/bin/bash

function echoerr {                                                                      
  printf "%s\n" "$*" >&2;             
}  

if [ $# -lt 1 ]; then
  echoerr "Files names not provided"
  exit
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
  read -n 1 -r -p "(Press \"y\" to ${action_name}): " input

  # new line but with stderr, escaping capture output
  echo >&2

  if [ "$input" != "Y" ] && [ "$input" != "y" ] && [ "$input" != "д" ] && [ "$input" != "Д" ]; then
    exit
  fi
  echo 1
}

echo 'See https://askubuntu.com/questions/1530084/rename-files-with-non-latin-characters/1530087#1530087'

rename -n -u utf8 'BEGIN {use Text::Unidecode}; unidecode($_)' "$@"

ASK_RESULT=$(ask_continue "rename files")

if [[ "$ASK_RESULT" != "1" ]]; then
  exit
fi

rename -u utf8 'BEGIN {use Text::Unidecode}; unidecode($_)' "$@"
