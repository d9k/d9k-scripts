#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

PROJECT_DIR=$HOME/repos/_e-commerce/ecommerce-by-golang-app

SQL_USER=ecommerce_by_golang_app
SQL_PASSWORD=$(pass servers/d9k_lap/psql/ecommerce_by_golang_app)
SQL_HOST=127.0.0.1
SQL_DB=ecommerce_by_golang_app
SQL_PORT=5437

if [[ -z "$SQL_PASSWORD" ]]; then
  echoerr "Error: password not defined"
  exit 100
fi

cd "$PROJECT_DIR"

# Проверка наличия утилиты migrate
if ! command -v migrate &> /dev/null; then
  echoerr "Error: 'migrate' command not found."
  echoerr
  echoerr "Please install it with:"
  echoerr "  go install -tags postgres github.com/golang-migrate/migrate/v4/cmd/migrate@latest"
  exit 200
fi

# https://github.com/golang-app/ecommerce

set -x
migrate -path ./migrations -database "postgres://$SQL_USER:$SQL_PASSWORD@:$SQL_PORT/$SQL_DB?sslmode=disable" up
