#!/bin/bash

# Hosting 
# https://github.com/sphireinc/Foundry

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

PROJECT_DIR=$HOME/repos/_cms/foundry

cd "$PROJECT_DIR"

echo "Running foundry from $PROJECT_DIR..."

( set -x; go run ./cmd/foundry version )

if [[ $? -ne 0 ]]; then
  echoerr "Version check failed"
  exit 100
fi

echo
echo "Starting foundry server..."
echo "Admin page: http://localhost:8080/__admin"
( set -x; go run ./cmd/foundry serve )
