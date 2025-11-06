#!/bin/bash

FILE_REL_PATH="$1"
FILE_NAME_WITH_EXT=$(basename "$FILE_REL_PATH")
FILE_DIR=$(dirname "$FILE_REL_PATH")
FILE_EXTENSION=$(echo "$FILE_NAME_WITH_EXT" | rev | cut -f 1 -d '.' | rev)

cd "$FILE_DIR"
FILES_SAME_EXT=$(ls *.$FILE_EXTENSION)

# echo -e "$FILES_SAME_EXT"
PREVIOUS_FILE=

while IFS= read -r CURRENT_FILE; do 
  # echo "> $CURRENT_FILE"
  if [[ "$CURRENT_FILE" == "$FILE_NAME_WITH_EXT" ]]; then
    break
  fi
  PREVIOUS_FILE="$CURRENT_FILE"
done <<< "$FILES_SAME_EXT"

echo "$FILE_DIR/$PREVIOUS_FILE"
