#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export ECOMMERCE_BY_GOLANG_APP_DIR="$HOME/forks/_e-commerce/ecommerce-by-golang-app"

exec "$SCRIPT_DIR/host-ecommerce-by-golang-app.sh" "$@"
