#!/bin/bash

SOURCE_CFG_DIR=~
BACKUP_CFG_DIR=~/scripts/cfg
CFG_FILE_REL_PATH=.textadept/init.lua

BACKUP_FILE_FULL_PATH="${BACKUP_CFG_DIR}/${CFG_FILE_REL_PATH}"
SOURCE_FILE_FULL_PATH="${SOURCE_CFG_DIR}/${CFG_FILE_REL_PATH}"

merge-util "${SOURCE_FILE_FULL_PATH}" "${BACKUP_FILE_FULL_PATH}"

echo "After merging data to \"${SOURCE_FILE_FULL_PATH}\":"

cd "${BACKUP_CFG_DIR}"
echo
git diff "${BACKUP_FILE_FULL_PATH}"
echo "${BACKUP_CFG_DIR}:"
git status .
