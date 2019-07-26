#!/bin/bash

# see http://www.solomonson.com/content/ubuntu-linux-text-speech

# DO:
# sudo apt-get install festival xsel sox festvox-ru

# ошибка LTS_Ruleset russian_downcase: no rule matches: LTS_Ruleset: # *here*
# cfg/patches/festival/msu_ru_nsh_lexicon.scm в
# /usr/share/festival/voices/russian/msu_ru_nsh_clunits/festvox/msu_ru_nsh_lexicon.scm

# https://gist.github.com/d9k/f6b7670d61e00840082dbc5d74be53f5

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

running=$(pgrep festival)
TEMPO=1.6
PITCH=-120

if [ -z $running ]
then

    TEMP_FILE_PATH=$(mktemp)

    xsel > ${TEMP_FILE_PATH}

    echo "=== Before fix ==="
    cat ${TEMP_FILE_PATH}

    ${CURRENT_PATH}/say-selection-ru-fix-file.sh ${TEMP_FILE_PATH}

    echo
    echo "=== After fix ==="
    cat ${TEMP_FILE_PATH}
    echo

    fest_opts="(Parameter.set 'Audio_Method 'Audio_Command)"
    fest_opts+="(Parameter.set 'Audio_Command "\""play -q -b 16 -c 1 -e signed-integer -r \$SR -t raw \$FILE tempo ${TEMPO} pitch ${PITCH}"\"")"
    fest_opts+="(tts_file \""${TEMP_FILE_PATH}"\" nil)"

    echo "${fest_opts}" | festival --pipe --language russian

    sleep 2

    rm ${TEMP_FILE_PATH}

else
    #kill it
    killall festival;killall audsp;killall play;sleep .1;killall play
fi
