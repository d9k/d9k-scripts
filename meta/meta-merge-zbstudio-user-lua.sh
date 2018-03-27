#!/bin/bash

CFG_PATH=~/scripts/cfg

FILE_REL_PATH=.zbstudio/user.lua

merge-util ~/${FILE_REL_PATH} "${CFG_PATH}/${FILE_REL_PATH}"

echo "After merging data to \"${CFG_PATH}\":"
echo
cd "${CFG_PATH}"
hg status .
