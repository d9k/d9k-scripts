#!/bin/bash

CFG_DIR_PATH=~/scripts-private/cfg/tor-browser

CFG_ORIG_PATH=~/.tor-browser-en/INSTALL/Browser/TorBrowser/Data/Tor/torrc
CFG_COPY_PATH="${CFG_DIR_PATH}/torrc"

mkdir -p $CFG_DIR_PATH

if [[ ! -f ${CFG_COPY_PATH} ]]; then
  touch ${CFG_COPY_PATH}
fi

MERGE_COMMAND="merge-util ${CFG_ORIG_PATH} ${CFG_COPY_PATH}"

echo "> $MERGE_COMMAND"
$MERGE_COMMAND

echo "After merging data to \"${CFG_PATH}\":"
echo
cd "${CFG_DIR_PATH}"
hg status .
