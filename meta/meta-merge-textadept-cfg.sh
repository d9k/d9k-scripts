#!/bin/bash

CFG_PATH=~/scripts/cfg

merge-util ~/.textadept/init.lua "${CFG_PATH}/.textadept/init.lua"

echo "After merging data to \"${CFG_PATH}\":"
echo
cd "${CFG_PATH}"
hg status .
