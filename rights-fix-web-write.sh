#!/bin/bash

DIR=$(pwd)

if [ -n "$1" ]; then
   DIR="$1"
fi

sudo chown -R $USER:www-data $DIR
sudo chmod -R ug+rw $DIR
