#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

help_exit() {
  echo "Help: ${SCRIPT_NAME} [-n|--number WINDOW_NUMBER] WINDOW_CLASS [COMMAND]
* WINDOW_CLASS: detect by running: wmctrl -lx
  "
  exit 1
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
WMCTRL_SEARCH_OUTPUT=$($SCRIPT_DIR/wmctrl-list-reorder.sh -x | grep --fixed-strings "${WINDOW_CLASS}" | sed -n ${WINDOW_NUMBER}p)

echo $WMCTRL_SEARCH_OUTPUT

WMCTRL_NUMBER=$(echo "$WMCTRL_SEARCH_OUTPUT" | awk '{print $1;}')

if [[ -z "$WMCTRL_NUMBER" ]]; then
  if [[ -n "$COMMAND" ]]; then
    eval $COMMAND
  else
    exit 2
  fi
  exit
fi

WMCTRL_NUMBER=$(printf "%d\n" ${WMCTRL_NUMBER})
echo WMCTRL_NUMBER: ${WMCTRL_NUMBER}

bash -c "$SCRIPT_DIR/focus-window-by-id.sh $WMCTRL_NUMBER"
