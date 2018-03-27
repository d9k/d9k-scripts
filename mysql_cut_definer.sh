#!/bin/bash

if [ $# -ne 2 ]; then
    echo "usage: cut_definer.sh IN_FILE OUT_FILE"
    exit
fi

if [ "$1" == "$2" ]; then
    echo "input and output files must be different!"
fi
 
sed '/SQL SECURITY DEFINER/d' $1 > $2
