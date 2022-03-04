#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

help_exit() {
  echo "Help: ${SCRIPT_NAME} [-n|--number WINDOW_NUMBER] WINDOW_CLASS [COMMAND]
* WINDOW_CLASS: detect by running: wmctrl -lx
  "
  exit
}

WINDOW_NUMBER=1

while [[ $# > 0 ]]; do
    OPTION="$1"

    case "$OPTION" in
        -n|--number)
            WINDOW_NUMBER="$2"
            shift # past argument
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

WINDOW_CLASS="$1"
#WINDOW_CLASS=Terminal
COMMAND="$2"

if [[ -z "$WINDOW_CLASS" ]]; then
  echo "WINDOW_CLASS not set"
  help_exit
fi

# -x: + WIN CLASS
WMCTRL_SEARCH_OUTPUT=$(wmctrl -lx | grep ${WINDOW_CLASS} | sed -n ${WINDOW_NUMBER}p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
  if [[ -n "$COMMAND" ]]; then
    eval $COMMAND
  fi
  exit
fi

WMCTRL_NUMBER=$(printf "%d\n" ${WMCTRL_NUMBER})
echo WMCTRL_NUMBER: ${WMCTRL_NUMBER}


FOCUSED_WMCTRL_NUMBER=$(xdotool getwindowfocus)
echo FOCUSED_WMCTRL_NUMBER: ${FOCUSED_WMCTRL_NUMBER}

if [[ "$FOCUSED_WMCTRL_NUMBER" == "$WMCTRL_NUMBER" ]]; then
  ALREADY_FOCUSED=1
fi


if [ -n "$ALREADY_FOCUSED" ]; then
  set -x
  #wmctrl -b toggle,shaded -a ${WMCTRL_NUMBER}
  xdotool windowminimize ${WMCTRL_NUMBER}
else
  set -x
  # -v: verbose
  # -i: int value, not caption text
  # -a: activate
  wmctrl -v -i -a  ${WMCTRL_NUMBER}
fi
