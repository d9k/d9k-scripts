#!/bin/bash

# sudo apt-get install -y coreutils
shuf -i 0-9999 -n 10 $@ | \
  `# pad with zeros` awk '{ printf("%04d\n", $1) }'
