#!/bin/bash

TIMEOUT="$1"

if [ -z "$TIMEOUT" ]; then
  TIMEOUT=60000
fi 

set -x
gsettings get org.gnome.mutter check-alive-timeout
gsettings set org.gnome.mutter check-alive-timeout "$TIMEOUT"
gsettings get org.gnome.mutter check-alive-timeout
