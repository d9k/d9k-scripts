#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$SCRIPT_DIR/inc/source_once.inc.sh"
source_once "$SCRIPT_DIR/inc/echoerr.inc.sh"

PROJECT_DIR=$HOME/repos/_e-commerce/ecommerce-by-golang-app

DB_HOST="127.0.0.1"
DB_USER="ecommerce_by_golang_app"
DB_NAME="ecommerce_by_golang_app"

#DB_PORT
eval "$(pass servers/d9k_lap/psql/info)"

function psqlLoginParams(){
  echo -e "--username=${DB_USER} \
    --port=${DB_PORT} \
    --host=${DB_HOST}"
}

function pgDumpParams(){
  echo -e "$(psqlLoginParams) \
    --no-privileges \
    --no-owner \
    --format=plain \
    --compress=none \
    ${DB_NAME}"
}

DB_PASSWORD=$(pass servers/d9k_lap/psql/ecommerce_by_golang_app)

if [[ -z "$DB_PASSWORD" ]]; then
  echoerr "Error: password not defined"
  exit 100
fi

if [ -z "$BACKUP" ]; then
  echoerr "BACKUP env not set"
  exit 200
fi

if [ ! -d "$BACKUP" ]; then
  echoerr "\"$BACKUP\" is not a directory"
  exit 300
fi

DB_BACKUP_DIR="$BACKUP/ecommerce-by-golang-app"
DB_NEW_BACKUP_DIR="$DB_BACKUP_DIR/new"
DB_NEW_BACKUP_PATH="$DB_NEW_BACKUP_DIR/backup.sql"
DB_BACKUP_PATH="$DB_BACKUP_DIR/backup.sql"

mkdir -p "$DB_BACKUP_DIR"

if [ -d "$DB_NEW_BACKUP_DIR" ]; then
  rm -r "$DB_NEW_BACKUP_DIR"
fi

mkdir -p "$DB_NEW_BACKUP_DIR"

echo "Creating backup from \"$DB_NAME\" on \"$DB_HOST:$DB_PORT\" to temporary file \"$DB_NEW_BACKUP_PATH\"..."

START_DATETIME=`date +%Y_%m_%d__%H_%M_%S`

DB_BACKUP_ARCHIVE_PATH="$DB_BACKUP_DIR/backup__${START_DATETIME}.tgz"

PGPASSWORD="${DB_PASSWORD}" pg_dump $(pgDumpParams) > "$DB_NEW_BACKUP_PATH"

cd "$DB_NEW_BACKUP_DIR"
tar -czvf "$DB_BACKUP_ARCHIVE_PATH" *
mv "${DB_NEW_BACKUP_PATH}" "${DB_BACKUP_PATH}"

echo "Backup saved to \"${DB_BACKUP_PATH}\""
echo "Backup archive saved to \"${DB_BACKUP_ARCHIVE_PATH}\""

cd "$DB_BACKUP_DIR"
echo "$DB_BACKUP_DIR:"
ls -lh
