#!/bin/bash

DUMP_PATH=~/scripts/cfg/cinnamon-keybindings.conf.dump
DCONF_REGISTRY_PATH="/org/cinnamon/desktop/keybindings/"

if [[ -f ${DUMP_PATH} ]]; then :; else echo "No config at \"${DUMP_PATH}\" available!"; exit 0; fi

read -p "Are you sure you want to override current keybindings from dump (y/n)?: " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then :; else exit 0; fi

dconf load "${DCONF_REGISTRY_PATH}" < ${DUMP_PATH}

