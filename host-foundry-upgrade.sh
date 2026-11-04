#!/bin/bash

# Post-pull upgrade for the host (non-docker) Foundry install.
# See https://github.com/sphireinc/Foundry
# See docs/installation-updates.md:
# modules -> plugin sync -> migrations -> version check.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

PROJECT_DIR=$HOME/repos/_cms/foundry

cd "$PROJECT_DIR" || { echoerr "Project dir not found: $PROJECT_DIR"; exit 1; }

echo "Upgrading foundry host install in $PROJECT_DIR..."
echo

echo "Step 1/4: Go modules (go.mod/go.sum may have changed after pull)..."
( set -x; go mod download )
if [[ $? -ne 0 ]]; then
  echoerr "go mod download failed"
  exit 1
fi

echo
echo "Step 2/4: regenerating plugin imports (internal/generated/plugins_gen.go)..."
( set -x; go run ./cmd/plugin-sync )
if [[ $? -ne 0 ]]; then
  echoerr "plugin-sync failed"
  exit 2
fi

echo
echo "Step 3/4: checking migrations..."
if grep -qE '^fields:' content/config/site.yaml; then
  echo "Legacy 'fields:' schema found in content/config/site.yaml."
  echo "Foundry 1.4.x expects field contracts in the theme manifest."
  read -r -p "Run 'foundry theme migrate field-contracts' now? [y/N] " ANSWER
  if [[ $ANSWER =~ ^[Yy] ]]; then
    ( set -x; go run ./cmd/foundry theme migrate field-contracts )
    if [[ $? -ne 0 ]]; then
      echoerr "theme migrate field-contracts failed"
      exit 3
    fi
  else
    echo "Skipped. Do it later manually:"
    echo "  go run ./cmd/foundry theme migrate field-contracts"
  fi
else
  echo "No legacy 'fields:' schema in content/config/site.yaml - nothing to migrate."
fi

echo
echo "Step 4/4: version check..."
( set -x; go run ./cmd/foundry version )
if [[ $? -ne 0 ]]; then
  echoerr "Version check failed"
  exit 4
fi

echo
echo "Upgrade complete. Start the server with: host-foundry.sh"
