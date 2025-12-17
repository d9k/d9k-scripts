#!/bin/bash

MAX_IN_LINE=6
NUM_IN_LINE=1

# https://unix.stackexchange.com/questions/60968/tmux-bottom-status-bar-color-change
for i in {0..255} ; do
    printf "\x1b[38;5;%smcolor%03d" "${i}" "${i}"
    if [[ "$NUM_IN_LINE" -ge "$MAX_IN_LINE" ]]; then
        printf "\n"
        NUM_IN_LINE=1
    else
        printf "    "
        let "NUM_IN_LINE=NUM_IN_LINE+1"
    fi
done
