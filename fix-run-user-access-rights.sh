#!/bin/bash

# UID=(id -u)
USER=$(whoami)
RUN_USER_DIR=/run/user/$UID
echo "Before fix:"
ls -al "$RUN_USER_DIR"

( set -x; sudo chown -R $USER "$RUN_USER_DIR" )

echo "After fix:"
ls -al "$RUN_USER_DIR"
