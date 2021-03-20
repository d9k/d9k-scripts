#!/bin/bash

#rename -n 's/[^\x00-\xEF]//g' *

#rename -n 's/[^\x00-\x7F\x410-\x44f]//g' *

# TODO почему \xF0 и больше нельзя?

#rename -n 's/[^\x00-\xEF]//g' *

#echo
#echo "Plz run:"
#echo "rename 's/[^\x00-\xEF]//g' *"

#Rename не работает

# \U requires bash 4.2+

# https://unicode-table.com
#rename -n 's/[^\U00000000-\U0000007F\U00000391-\U0000044F]//g' *
#rename -n 's/[^\U00000410]//g' *
#не работает

# ========================================

# Не работает код ниже: No files to rename found

#function build_command() {
## TODO почему \xF0 и больше нельзя?
##rename $@ "s/^\x00-\xEF//g" *
#cat <<- END
#rename $@ 's/^\x00-\xEF//g' *
#END
#}
#
#COMMAND=$(build_command)
#COMMAND_N=$(build_command -n)
#EVAL_RESULT=
#
#function echo_and_eval() {
#  echo "> $@"
#  EVAL_RESULT=$(eval "$@")
#  echo "$EVAL_RESULT"
#}
#
#function ask_continue { action_name=$1
#  if [[ -z "${action_name}" ]]; then
#    action_name="continue"
#  fi
#
#  # -s	        do not echo input coming from a terminal
#  # -p          prompt	output the string PROMPT without a trailing newline before
#  #       attempting to read
#  # -r  	  	  do not allow backslashes to escape any characters
#  # -n nchars	  return after reading NCHARS characters rather than waiting
#  #    		for a newline,
#  read -n 1 -r -p "Press \"y\" to ${action_name}: " input
#
#  # new line but with stderr, escaping capture output
#  echo >&2
#
#  if [ "$input" != "Y" ] && [ "$input" != "y" ] && [ "$input" != "д" ] && [ "$input" != "Д" ]; then
#    exit
#  fi
#  echo 1
#}
#
#
## quotes required!
#echo_and_eval "$COMMAND_N"
#
#if [[ -z "$EVAL_RESULT" ]]; then
#  echo "No files to rename found"
#  exit;
#fi
#
#if [[ "$(ask_continue rename)" != "1" ]]; then
#  exit;
#fi
#
#echo_and_eval "$COMMAND"
#
