#!/bin/bash

# VSCode integration:
#
# tasks.json:
#
#  "tasks": [
#    {
#      "label": "cpp add header file ifdef",
#      "type": "shell",
#      "command": "/home/d9k/scripts/cpp-add-header-file-ifdef.sh ${file} ${workspaceFolder}",
#      "presentation": {
#        "echo": true,
#        "reveal": "always",
#        "focus": true,
#        "close": false,
#        "panel": "shared",
#        "clear": true
#      },
#      "problemMatcher": []
#    },

function echoerr {
  printf "%s\n" "$*" >&2;
}

function echo_help {                                     
  echoerr "Examples:"
  echoerr "    cpp-add-header-file-ifdef.sh OUTPUT_FILE PROJECT_DIR"
}

if [ "$#" -lt 2 ]; then
  echo_help
  exit
fi

OUTPUT_FILE="$1"
PROJECT_DIR="$2"

echo "OUTPUT_FILE: $OUTPUT_FILE" 
echo "PROJECT_DIR: $PROJECT_DIR" 

INPUT_STRINGS=$(cat "$OUTPUT_FILE")

# echo "# Content: "
# echo "$INPUT_STRINGS"

FILE_REL_PATH=$(realpath -s --relative-to="$PROJECT_DIR" "$OUTPUT_FILE")

echo "FILE_REL_PATH: $FILE_REL_PATH" 

FILE_REL_PATH_STRIPPED=$( \
  echo "$FILE_REL_PATH" \
  | sed 's|include/||' \
)

echo "FILE_REL_PATH_STRIPPED: $FILE_REL_PATH_STRIPPED" 

CONST_NAME=$(
  echo "$FILE_REL_PATH_STRIPPED" \
  | sed 's|/|_|g' \
  | sed 's|\.|_|g' \
  | sed 's|-|_|g' \
  | awk '{ print toupper($0) }'
)

echo "CONST_NAME: $CONST_NAME" 

OUTPUT_STRINGS="#ifndef $CONST_NAME
#define $CONST_NAME

$INPUT_STRINGS

#endif // $CONST_NAME"

printf "$OUTPUT_STRINGS" > "$OUTPUT_FILE"
