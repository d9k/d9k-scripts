#!/bin/bash

SOURCE_CFG_DIR=~/.config/zathura
BACKUP_CFG_DIR=~/scripts/cfg
CFG_FILE_REL_PATH=zathurarc

SOURCE_FILE_FULL_PATH="${SOURCE_CFG_DIR}/${CFG_FILE_REL_PATH}"
BACKUP_FILE_FULL_PATH="${BACKUP_CFG_DIR}/${CFG_FILE_REL_PATH}"

if [[ ! -f "$BACKUP_FILE_FULL_PATH" ]]; then
  echo "File \"$BACKUP_FILE_FULL_PATH\" doesn't exist. Creating new file..."
  touch "$BACKUP_FILE_FULL_PATH"
fi

merge-util "${SOURCE_FILE_FULL_PATH}" "${BACKUP_FILE_FULL_PATH}"

echo "After merging data to \"${BACKUP_FILE_FULL_PATH}\":"
echo
cd "${BACKUP_CFG_DIR}"
echo
git diff "${BACKUP_FILE_FULL_PATH}"
git status .
echo "You can:"
echo "\`cd ${BACKUP_CFG_DIR}\`"
