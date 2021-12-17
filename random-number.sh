#!/bin/bash

# sudo apt-get install -y coreutils
shuf -i 1000-9000 -n 10 $@
