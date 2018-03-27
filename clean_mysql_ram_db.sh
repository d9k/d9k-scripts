#!/bin/bash -xEe
i=$1
pass=test
if [ -z "$i" ]; then
  echo "Missing argument: instance number."
  exit 1
fi

port=$[3306+$i]
pid=`cat "/var/run/mysqld/mysqld$i.pid" || true`
if [ -n "$pid" ]; then
    kill -9 $pid
    while kill -0 $pid; do
        sleep 0.5
    done
fi
sleep 2.0

umount -l "/var/lib/mysql$i" || true
rm -rf "/var/lib/mysql$i"
rm -rf "/etc/mysql$i"

if [ ! -f /etc/apparmor.d/disable/usr.sbin.mysqld ]; then
    touch /etc/apparmor.d/disable/usr.sbin.mysqld
    service apparmor reload
fi

#addition
unlink /var/run/mysqld/mysqld$i.sock || true

