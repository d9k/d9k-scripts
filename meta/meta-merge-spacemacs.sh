#!/bin/bash

CFG_PATH=~/scripts/cfg

merge-util ~/.spacemacs "${CFG_PATH}/.spacemacs"

echo "After merging data to \"${CFG_PATH}\":"
echo
cd "${CFG_PATH}"
hg status .
