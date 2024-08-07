#!/bin/bash

CFG_DIR=~
CFG_BACKUP_DIR=~/scripts/cfg/rofi
FOLDER_REL_PATH=.config/rofi

mkdir -p "${CFG_BACKUP_DIR}"

meld "$CFG_DIR/${FOLDER_REL_PATH}" "${CFG_BACKUP_DIR}"

echo "After merging data to \"${CFG_BACKUP_DIR}\":"
echo
cd "${CFG_BACKUP_DIR}"
git diff "${CFG_BACKUP_DIR}/${FOLDER_REL_PATH}"
echo "${CFG_BACKUP_DIR}:"
git status .
