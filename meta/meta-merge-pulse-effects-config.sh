#!/bin/bash

COMPARE_DIRS_TOOL=meld
CONFIG_DIR=/home/d9k/scripts-private/cfg/PulseEffects
BACKUP_CONFIG_DIR=~/.var/app/com.github.wwmm.pulseeffects/config/PulseEffects/output

${COMPARE_DIRS_TOOL} "${CONFIG_DIR}" "${BACKUP_CONFIG_DIR}"
