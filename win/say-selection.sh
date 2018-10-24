#!/bin/bash

# see http://www.solomonson.com/content/ubuntu-linux-text-speech

# DO:
# sudo apt-get install festival xsel sox festvox-kallpc16k

# deprecated: also need config from cfg/.festivalrc

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

running=$(pgrep festival)
TEMPO=1.0
PITCH=-133

if [ -z $running ]
then
    #read it
    #xsel | festival --tts --pipe
    #echo "(Parameter.set 'Audio_Command \""play -b 16 -c 1 -e signed-integer -r $SR -t raw $FILE tempo 1.2 pitch -200"\") (Parameter.set 'Audio_Method 'Audio_Command) (SayText \"" $(xsel) "\")" | festival --pipe

    #echo "(Parameter.set 'Audio_Command "\""play -q -b 16 -c 1 -e signed-integer -r \$SR -t raw \$FILE tempo ${TEMPO} pitch ${PITCH}"\"") (Parameter.set 'Audio_Method 'Audio_Command) (SayText \"" $(xsel) "\")" | festival --pipe

    TEMP_FILE_PATH=$(mktemp)

    #TEMP_FILE_PATH=/tmp/t

    xsel > ${TEMP_FILE_PATH}

    echo "=== Before fix ==="
    cat ${TEMP_FILE_PATH}

    ${CURRENT_PATH}/say-selection-en-fix-file.sh ${TEMP_FILE_PATH}

    echo
    echo "=== After fix ==="
    cat ${TEMP_FILE_PATH}
    echo

    # echo "(Parameter.set 'Audio_Command "\""play -q -b 16 -c 1 -e signed-integer -r \$SR -t raw \$FILE tempo ${TEMPO} pitch ${PITCH}"\"") (Parameter.set 'Audio_Method 'Audio_Command) (tts \""${TEMP_FILE_PATH}"\" nil)"

    echo "(Parameter.set 'Audio_Command "\""play -q -b 16 -c 1 -e signed-integer -r \$SR -t raw \$FILE tempo ${TEMPO} pitch ${PITCH}"\"") (Parameter.set 'Audio_Method 'Audio_Command) (tts_file \""${TEMP_FILE_PATH}"\" nil)" | festival --pipe

    sleep 5

    #echo "(tts \""${TEMP_FILE_PATH}"\" nil)" | festival --pipe --batch

    rm ${TEMP_FILE_PATH}

else
    #kill it
    killall festival;killall audsp;killall play;sleep .1;killall play
fi
