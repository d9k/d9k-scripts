#!/bin/bash
if [ $# -ne 1 ]; then
    echo "need dir arg"
    exit
fi
find $1 -type d -exec chmod g+x {} +