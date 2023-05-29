#!/bin/bash

# https://launchpad.net/~linvinus/+archive/ubuntu/rhvoice/
#
# sudo apt-get install rhvoice rhvoice-english rhvoice-russian
# sudo apt-get install xsel sox

SCRIPTS="$HOME/scripts"
SCRIPT_RHVOICE_FIXED="$SCRIPTS/rhvoice-fixed.sh"

killall RHVoice-client
killall RHVoice-service
sleep 1
RHVoice-service &
sleep 1



#xsel | RHVoice-client -r 0.5 -v 0.8 -p 0.05 -s Aleksandr+Alan | aplay

# TODO пропадает часть слов в начала текста: временно сохраняю в промежуточный файл.
#   Но вообще с запущенным pavucontrol не дожно быть проблем

#xsel | "$SCRIPT_RHVOICE_FIXED" | aplay
xsel | "$SCRIPT_RHVOICE_FIXED" > /tmp/t.wav
sleep 1
aplay /tmp/t.wav
sleep 1
killall RHVoice-service
#xsel | RHVoice-client -r 0.5 -v 0.8 -p 0.05 -s Irina+Alan | aplay

