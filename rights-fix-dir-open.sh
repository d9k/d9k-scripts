#!/bin/bash
set -x
find $1 -type d -exec chmod a+rx {} \;
