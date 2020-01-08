#!/bin/bash

if [ $# -ne 1 ]; then
    echo "need dir arg"
    exit
fi

set -x
find $1 -type d -exec chmod a+rx {} \;
