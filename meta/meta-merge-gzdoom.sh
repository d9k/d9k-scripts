#!/bin/bash

CFG_DIR=~/.config/gzdoom
CFG_BACKUP_DIR=~/scripts/cfg/gzdoom
FILE_REL_PATH=gzdoom-user.ini
CFG_IN="$CFG_DIR/${FILE_REL_PATH}"
CFG_OUT="${CFG_BACKUP_DIR}/${FILE_REL_PATH}"

if [[ ! -f "${CFG_OUT}" ]]; then
  touch "${CFG_OUT}"
fi

merge-util "$CFG_IN" "$CFG_OUT"

echo "After merging data to \"${CFG_BACKUP_DIR}\":"
echo
cd "${CFG_BACKUP_DIR}"
git diff "${CFG_BACKUP_DIR}/${FILE_REL_PATH}"
echo "${CFG_BACKUP_DIR}:"
git status .
