#!/bin/bash

# https://launchpad.net/~linvinus/+archive/ubuntu/rhvoice/
#
# sudo apt-get install rhvoice rhvoice-english rhvoice-russian
# sudo apt-get install xsel sox

SCRIPTS="$HOME/scripts"
SCRIPT_RHVOICE_FIXED="$SCRIPTS/rhvoice-fixed.sh"

killall RHVoice-client && sleep 3

#xsel | RHVoice-client -r 0.5 -v 0.8 -p 0.05 -s Aleksandr+Alan | aplay

xsel | "$SCRIPT_RHVOICE_FIXED" | aplay

#xsel | RHVoice-client -r 0.5 -v 0.8 -p 0.05 -s Irina+Alan | aplay
