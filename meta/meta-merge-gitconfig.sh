#!/bin/bash

CFG_DIR=~
CFG_BACKUP_DIR=~/scripts/cfg
FILE_REL_PATH=.gitconfig

merge-util "$CFG_DIR/${FILE_REL_PATH}" "${CFG_BACKUP_DIR}/${FILE_REL_PATH}"

echo "After merging data to \"${CFG_BACKUP_DIR}\":"
echo
cd "${CFG_BACKUP_DIR}"
git diff "${CFG_BACKUP_DIR}/${FILE_REL_PATH}"
echo "${CFG_BACKUP_DIR}:"
git status .
