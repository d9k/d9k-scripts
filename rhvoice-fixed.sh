#!/bin/bash

# https://launchpad.net/~linvinus/+archive/ubuntu/rhvoice/
#
# sudo apt-get install rhvoice rhvoice-english rhvoice-russian
# sudo apt-get install xsel sox

# `example-pipe-read`

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INPUT=

if [ ! -t 0 ]; then
  #echo "(pipe has data)"

  INPUT=$(< /dev/stdin)
else
  #echo "(no pipe)"
  INPUT="$@"
fi


echo "$INPUT" | "$CURRENT_PATH/rhvoice-fix-file.sh" | RHVoice-client -r 0.5 -v 0.8 -p 0.05 -s Aleksandr+Alan

