#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CFG_PATH=$1

if [[ -z "$CFG_PATH" ]]; then
  echo "config path argument required!"
  exit 1
fi

source $CFG_PATH

#source "$DIR/docker-mariadb-prod-replication-config.inc.sh"

docker rm --force ${CONTAINER_NAME}
