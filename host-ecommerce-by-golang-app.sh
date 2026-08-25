#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

PROJECT_DIR=$HOME/repos/_e-commerce/ecommerce-by-golang-app
BACKEND_DIR="$PROJECT_DIR/backend"
BUILD_DIR="$PROJECT_DIR/build/backend"

# Database configuration
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5437
export POSTGRES_USER=ecommerce_by_golang_app
export POSTGRES_DB=ecommerce_by_golang_app
export POSTGRES_PASSWORD=$(pass servers/d9k_lap/psql/ecommerce_by_golang_app)

# Application configuration
export UPLOADS_DIR="$BACKEND_DIR/data/uploads"
export BASE_URL=http://localhost:8080

# OpenTelemetry: disable exporter since no collector is running locally
export OTEL_EXPORTER_OTLP_ENDPOINT=""

if [[ -z "$POSTGRES_PASSWORD" ]]; then
  echoerr "Error: POSTGRES_PASSWORD not defined"
  exit 100
fi

cd "$BACKEND_DIR"

echo "Building backend from $BACKEND_DIR..."
mkdir -p "$BUILD_DIR"
( set -x; go build -o "$BUILD_DIR/web" ./cmd/web )

if [[ $? -ne 0 ]]; then
  echoerr "Build failed"
  exit 100
fi

echo "Running backend..."
( set -x; "$BUILD_DIR/web" )
