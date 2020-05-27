#!/bin/bash

REPO_CFG_PATH=~/scripts/cfg
CFG_NAME=.tmux.conf

merge-util ~/${CFG_NAME} "${REPO_CFG_PATH}/${CFG_NAME}"

echo "After merging data to \"${REPO_CFG_PATH}\":"
echo
cd "${REPO_CFG_PATH}"


git diff "${REPO_CFG_PATH}/${CFG_NAME}"
echo
git status .
