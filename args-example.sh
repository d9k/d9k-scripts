#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

help_exit() {
  echo "Help: ${SCRIPT_NAME} [-u USER_NAME] [-e] [ADDITIONAL_MESSAGE]"
  exit
}

USERNAME=user
MESSAGE_END="."


while [[ $# > 0 ]]; do
    OPTION="$1"

    case "$OPTION" in
        -u|--user)
            USERNAME="$2"
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

ADDITIONAL_STRING="$1"

echo "Hello, ${USERNAME}${MESSAGE_END} ${ADDITIONAL_STRING}"
