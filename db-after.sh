#!/bin/bash

SCRIPTNAME=`basename "$0"`

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/ps/ps-mysql.inc.sh
source $DIR/lib/mysql.inc.sh

DIFF_APP=$1
if [ -z "${DIFF_APP}" ]; then
	DIFF_APP="kdiff3"
fi

DB_BEFORE_NAME_FILE_PATH="${DIR}/temp/.db-before-name.temp"
DB_BEFORE_FILE_PATH="${DIR}/temp/db-before.sql"
DB_AFTER_FILE_PATH="${DIR}/temp/db-after.sql"

if [ ! -f ${DB_BEFORE_FILE_PATH} ]; then
	echo "Database not found at \"${DB_BEFORE_FILE_PATH}\""
	exit 1
fi

if [ ! -f ${DB_BEFORE_NAME_FILE_PATH} ]; then
	echo "can't find last database name at \"${DB_BEFORE_NAME_FILE_PATH}\""
	exit 1
fi

DB_TO_BACKUP=$( cat "${DIR}/temp/.db-before-name.temp" )

if [ -z "${DB_TO_BACKUP}" ]; then
	echo "can't find last database name at \"${DB_BEFORE_NAME_FILE_PATH}\""
	exit 1
fi

echo "Executing backup for \"${DB_TO_BACKUP}\" database..."

mysqldump $(mysqlParams) "${DB_TO_BACKUP}" > ${DB_AFTER_FILE_PATH}

ls -l "${DB_BEFORE_FILE_PATH}" "${DB_AFTER_FILE_PATH}"

${DIFF_APP} "${DB_BEFORE_FILE_PATH}" "${DB_AFTER_FILE_PATH}" &
