#!/bin/bash

SOURCE_CFG_DIR=~
BACKUP_CFG_DIR=~/scripts/cfg
CFG_FILE_REL_PATH=.tigrc


SOURCE_FILE_FULL_PATH="${SOURCE_CFG_DIR}/${CFG_FILE_REL_PATH}"
BACKUP_FILE_FULL_PATH="${BACKUP_CFG_DIR}/${CFG_FILE_REL_PATH}"

merge-util "${SOURCE_FILE_FULL_PATH}" "${BACKUP_FILE_FULL_PATH}"

echo "After merging data to \"${BACKUP_FILE_FULL_PATH}\":"
echo
cd "${BACKUP_CFG_DIR}"
echo
git diff "${BACKUP_FILE_FULL_PATH}"
git status .
echo "You can:"
echo "\`cd ${BACKUP_CFG_DIR}\`"
