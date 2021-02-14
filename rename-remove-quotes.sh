#!/bin/bash

function build_command() {
cat <<- END
rename $@ "s/'//g" *
END
}

COMMAND=$(build_command)
COMMAND_N=$(build_command -n)
EVAL_RESULT=

function echo_and_eval() {
  echo "> $@"
  EVAL_RESULT=$(eval "$@")
}

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


# quotes required!
echo_and_eval "$COMMAND_N"

if [[ -z "$EVAL_RESULT" ]]; then
  echo "No files to rename found"
  exit;
fi

if [[ "$(ask_continue rename)" != "1" ]]; then
  exit;
fi

echo_and_eval "$COMMAND"
