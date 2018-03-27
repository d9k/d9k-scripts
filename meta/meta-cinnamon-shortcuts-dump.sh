#!/bin/bash

DUMP_PATH=~/scripts/cfg/cinnamon-keybindings.conf.dump
DCONF_REGISTRY_PATH="/org/cinnamon/desktop/keybindings/"
dconf dump "${DCONF_REGISTRY_PATH}" > ${DUMP_PATH}
ls -l ${DUMP_PATH}