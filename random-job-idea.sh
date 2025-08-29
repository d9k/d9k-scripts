#!/bin/bash

# https://t.me/ctobtch/483

curl -s https://classifikators.ru/assets/downloads/okved/okved.csv | iconv -f windows-1251 -t utf-8 | sed 's/.*;\s*//g' | sort -R | head -1
