#!/bin/bash

SCRIPTNAME=`basename "$0"`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DB_BEFORE_NAME_FILE_PATH="${DIR}/temp/.db-before-name.temp"

source $DIR/ps/ps-mysql.inc.sh
source $DIR/lib/mysql.inc.sh

if [ -f ${DB_BEFORE_FILE_PATH} ]; then
	param_db_name_part=$( cat "${DB_BEFORE_NAME_FILE_PATH}" )
	echo "\"${param_db_name_part}\" db name from last run found at \"${DB_BEFORE_NAME_FILE_PATH}\""
fi

if [ -z "${param_db_name_part}" ]; then
	param_db_name_part=$1

	if [ -z "${param_db_name_part}" ]; then
		echo "Usage: $SCRIPTNAME db_name_part"
		exit 1
	fi
fi

DB_TO_BACKUP=$( mysql $(mysqlParams) --batch --skip-column-names -e "SHOW DATABASES;" | grep "${param_db_name_part}" | head -1 )

if [ -z "${DB_TO_BACKUP}" ]; then
	echo "Database with pattern \"${param_db_name_part}\" not found"
	exit 1
fi

echo "Database \"${DB_TO_BACKUP}\" found. Executing backup..."

mysqldump $(mysqlParams) "${DB_TO_BACKUP}" > $DIR/temp/db-before.sql

ls -l $DIR/temp/db-before.sql

echo "${DB_TO_BACKUP}" > ${DB_BEFORE_NAME_FILE_PATH}