#!/bin/bash

CFG_PATH=~/scripts/cfg

cp ~/.emacs "${CFG_PATH}"
cp -r ~/emacs "${CFG_PATH}"


echo "After copying data to \"${CFG_PATH}\":"
echo
cd "${CFG_PATH}"
hg status .
