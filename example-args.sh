#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

help_exit() {
  echo "Help: ${SCRIPT_NAME} [--exclamate] [--greeting GREETING] USER_NAME [ADDITIONAL_MESSAGE]"
  exit
}

GREETING="Hello"
MESSAGE_END="."

while [[ $# > 0 ]]; do
    OPTION="$1"

    case "$OPTION" in
        -g|--greeting)
            GREETING="$2"
            shift # past argument
        ;;
        -e|--exclamate) # argument without value
            MESSAGE_END="!"
        ;;
        -h|--help)
            help_exit
        ;;
        *)
          if [[ "${OPTION:0:1}" == "-" ]]; then
            echo -e "Error: unknown option \"$OPTION\" \n"
            help_exit
          else
            break
          fi
        ;;
    esac
    shift # past argument or value
done

# Arguments count check
if [ "$#" -lt 1 ]; then
  show_help
  exit 1
fi


USERNAME="$1"
ADDITIONAL_MESSAGE="$2"

echo "${GREETING}, ${USERNAME}${MESSAGE_END} ${ADDITIONAL_MESSAGE}"
