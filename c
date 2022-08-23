#!/bin/bash

# Copy nth line from piped input
# Usage: `c [line_num]`
# line_num can be negative (from end)

#https://stackoverflow.com/questions/2559076/how-do-i-redirect-output-to-a-variable-in-shell
PIPE_INPUT=$(< /dev/stdin)

export LD_PRELOAD=

echo -n "$PIPE_INPUT" | select-line $@ | xclip -selection c
