#!/bin/bash

CFG_DIR=~/.config/gzdoom
FILE_REL_PATH_IN=gzdoom-user-temp.ini
FILE_REL_PATH_OUT=gzdoom-user.ini
CFG_IN="${CFG_DIR}/${FILE_REL_PATH_IN}"
CFG_OUT="${CFG_DIR}/${FILE_REL_PATH_OUT}"


merge-util "$CFG_IN" "$CFG_OUT"
