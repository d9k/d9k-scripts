#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CFG_PATH=$1

if [[ -z "$CFG_PATH" ]]; then
  echo "config path argument required!"
  exit 1
fi

source $CFG_PATH

docker exec -it ${CONTAINER_NAME} mariabackup --backup --user root --password ${MYSQL_ROOT_PASSWORD} --target-dir /backup/$(date +"%Y_%m_%d__%H_%M")
