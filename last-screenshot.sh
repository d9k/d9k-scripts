#!/bin/bash

last_n=$1

if [[ -z "$last_n" ]]; then
  last_n=1
fi

cd ~/Downloads
screenshot_name=$(ls -rt Screenshot* | tail -n $last_n | head -n 1)
screenshot_path=$(readlink -f "$screenshot_name")

echo "${screenshot_path}"
gpicview "${screenshot_path}"
