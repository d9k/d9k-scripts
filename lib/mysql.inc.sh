function mysqlParams(){
	echo "-u${MYSQL_USER} -P${MYSQL_PORT} -p${MYSQL_PASSWORD} -h${MYSQL_HOST}"
}