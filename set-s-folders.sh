#!/bin/bash

if [[ "$#" -lt 1 ]]; then
  echo 'usage: set-s-folders dir_path'
  exit
fi

# http://en.wikipedia.org/wiki/Setuid
sudo find $1 -type d -exec chmod g+s '{}' \;