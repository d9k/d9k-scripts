#!/bin/bash

CFG_DIR=~
REPO_CFG_PATH=~/scripts-private/cfg
FILE_REL_PATH=.aliases-private

FILE_FULL_PATH="${REPO_CFG_PATH}/${FILE_REL_PATH}"

( set -x; merge-util $CFG_DIR/${FILE_REL_PATH} ${FILE_FULL_PATH} )

echo "After merging data to \"${REPO_CFG_PATH}\":"

cd "${REPO_CFG_PATH}"
echo
git diff "${FILE_FULL_PATH}"
echo "${REPO_CFG_PATH}:"
git status .
