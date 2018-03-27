#!/bin/bash
$TODO create bitrix-bdb.sh
source ~/.aliases
cd $IRK
mkdir .backupdb
mysqldump -uroot -p kinoirk > .backupdb/backup.sql
ls -l .backupdb/backup.sql