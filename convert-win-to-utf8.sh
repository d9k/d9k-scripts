#!/bin/bash
FILE_PATH_REL=$1

if [[ -z ${FILE_PATH_REL} ]]; then
  echo "You must specify path to file"
fi

FILE_PATH=$(readlink -f ${FILE_PATH_REL})
FILE_NAME=$(basename ${FILE_PATH})
FILE_EXT_ONLY=$(echo "$FILE_NAME" | cut -d'.' -f2-)
FILE_NAME_ONLY=$(basename "$FILE_NAME" | cut -d'.' -f-1)
DIR_PATH=$(dirname ${FILE_PATH})

OUTPUT_PATH=${DIR_PATH}/${FILE_NAME_ONLY}_utf.${FILE_EXT_ONLY}

iconv -f cp1251 -t utf8 ${FILE_PATH} > ${OUTPUT_PATH}

ls -l ${FILE_PATH} ${OUTPUT_PATH}