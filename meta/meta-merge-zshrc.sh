#!/bin/bash

CFG_DIR=~
REPO_CFG_PATH=~/scripts/cfg
FILE_REL_PATH=.zshrc

FILE_FULL_PATH="${REPO_CFG_PATH}/${FILE_REL_PATH}"

merge-util $CFG_DIR/${FILE_REL_PATH} ${FILE_FULL_PATH}

echo "After merging data to \"${FILE_FULL_PATH}\":"

cd "${REPO_CFG_PATH}"
echo
git diff "${FILE_FULL_PATH}"
git status .
