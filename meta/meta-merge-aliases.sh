#!/bin/bash

CFG_PATH=~/scripts-private/cfg

merge-util ~/.aliases "${CFG_PATH}/.aliases"

echo "After merging data to \"${CFG_PATH}\":"
echo
cd "${CFG_PATH}"
hg status .
