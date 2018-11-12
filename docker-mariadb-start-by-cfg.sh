#!/bin/bash

# see cfg/templates/docker-mariadb-config.sh.template for config template

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CFG_PATH=$1

if [[ -z "$CFG_PATH" ]]; then
  echo "config path argument required!"
  exit 1
fi

source $CFG_PATH

#source "$DIR/docker-mariadb-prod-replication-config.inc.sh"

if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then

    docker pull mariadb:${DOCKER_IMAGE_VERSION}

    # see doc https://docs.docker.com/engine/reference/commandline/run/
    # see `docker run mariadb --verbose --help` for list of available arguments
    docker run \
        --rm \
        --name ${CONTAINER_NAME} \
        --publish ${MYSQL_MAP_TO_HOST_PORT}:3306 \
        --env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
        --volume ${MYSQL_DATA_DIR}:/var/lib/mysql/:z \
        --volume ${MYSQL_BACKUP_DIR}:/backup:z \
        --detach \
        mariadb:${DOCKER_IMAGE_VERSION} \
        --sql-mode=TRADITIONAL \
        --server-id=${SERVER_ID}

# --volume: :z means "shared"
# -v ${DIR}/mysql-init-test.d:/docker-entrypoint-initdb.d \
# --tmpfs /var/lib/mysql:rw \

else
  echo 'Container is already running'
fi

echo "Data at \"$MYSQL_DATA_DIR\""

echo "Container name is ${CONTAINER_NAME}"
echo see https://mariadb.com/kb/en/library/installing-and-using-mariadb-via-docker/ for commands

echo
echo "Commands:"
echo "show logs: docker logs ${CONTAINER_NAME}"
echo "bash into container: docker exec -it ${CONTAINER_NAME} bash"


