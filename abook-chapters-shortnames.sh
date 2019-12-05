#!/bin/bash

CHAPTER_PREFIX=часть_

# copy files to chapter/ folder renaming them to [chapter_prefix][number].mp3
CHAPTERS_FOLDER=chapters

if [[ -z "$1" ]]; then
  THIS_NAME="$(basename $0)"
  echo "Usage: ${THIS_NAME} file_name_1 [...file_name_n]"
  exit
fi

for ARG; do
  #echo $ARG
  FILE_NAME_WITH_EXT="$ARG"

  echo "# $FILE_NAME_WITH_EXT"

  FILE_EXTENSION=$(echo "$FILE_NAME_WITH_EXT" | rev | cut -f 1 -d '.' | rev)

  if [[ "$FILE_EXTENSION" != "mp3" ]]; then
    echo "unknown extension. skipping"
    continue
  fi

  FILE_NAME_NO_EXT=$(echo "$FILE_NAME_WITH_EXT" | sed -e s/\.${FILE_EXTENSION}$//g)

  #echo $FILE_EXTENSION
  #echo $FILE_NAME_NO_EXT

  FILE_NUM_PART=$(echo "$FILE_NAME_WITH_EXT" | grep -o '[0-9]\+' | head -n 1)


  DIR="$(dirname """$FILE_NAME_WITH_EXT""")"
  #echo $DIR
  CHAPTERS_PATH="$DIR/$CHAPTERS_FOLDER"
  mkdir -p "${CHAPTERS_PATH}"

  CP_DEST_NAME="${CHAPTER_PREFIX}${FILE_NUM_PART}.${FILE_EXTENSION}"
  CP_DEST_PATH="${CHAPTERS_PATH}/${CP_DEST_NAME}"

  echo "Copying to $CP_DEST_PATH"
  cp "$FILE_NAME_WITH_EXT" "$CP_DEST_PATH"

  echo
done
