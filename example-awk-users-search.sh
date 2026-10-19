#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
INPUT_PATH=$SCRIPT_DIR/res/example/users.csv
MIN_AGE=18

echo "Filtering age > $MIN_AGE from \"$INPUT_PATH\":"

awk -F';' '
    BEGIN {
        ID = 1
        USERNAME = 2
        EMAIL = 3
        AGE   = 4
        MIN_AGE = '$MIN_AGE'
    }
    # Skip headers (first line)
    NR == 1 { next }
    $AGE >= MIN_AGE { print $ID, $USERNAME, $EMAIL }
' "$INPUT_PATH"
