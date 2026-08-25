#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

PROJECT_DIR=$HOME/repos/_e-commerce/ecommerce-by-golang-app
BACKEND_DIR="$PROJECT_DIR/backend"

# Database configuration
export POSTGRES_PORT=$(pass-env servers/d9k_lap/psql/info DB_PORT)
export POSTGRES_HOST=localhost
export POSTGRES_USER=ecommerce_by_golang_app
export POSTGRES_DB=ecommerce_by_golang_app
export POSTGRES_PASSWORD=$(pass servers/d9k_lap/psql/ecommerce_by_golang_app)

if [[ -z "$POSTGRES_PASSWORD" ]]; then
  echoerr "Error: POSTGRES_PASSWORD not defined"
  exit 100
fi

cd "$BACKEND_DIR"

echo "=== Seeding database ==="
( set -x; go run ./cmd/cli seeds )

if [[ $? -ne 0 ]]; then
  echoerr "Seeds failed"
  exit 200
fi

echo "=== Seeding complete ==="
echo "Admin credentials: admin@example.com / Admin123!"
