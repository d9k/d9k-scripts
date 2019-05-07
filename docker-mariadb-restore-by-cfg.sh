#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CFG_PATH=$1

if [[ -z "$CFG_PATH" ]]; then
  echo "config path argument required!"
  exit 1
fi

source $CFG_PATH

#source "$DIR/docker-mariadb-prod-replication-config.inc.sh"

#docker rm --force ${CONTAINER_NAME}

echo "Trying to restore from ${MYSQL_BACKUP_DIR}/restore"

# Notice: ${MYSQL_BACKUP_DIR}/restore is mapped to /backup/restore inside the container

docker exec -it ${CONTAINER_NAME} mariabackup --prepare --user root --password ${MYSQL_ROOT_PASSWORD} --target-dir /backup/restore
docker exec -it ${CONTAINER_NAME} mariabackup --copy-back --user root --password ${MYSQL_ROOT_PASSWORD} --target-dir /backup/restore

# TODO see https://mariadb.com/kb/en/library/full-backup-and-restore-with-mariabackup/
# "Bear in mind, the data directory must be empty before restoring the backup."
