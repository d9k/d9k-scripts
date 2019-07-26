#!/bin/bash

# "lame" required

# see http://www.solomonson.com/content/ubuntu-linux-text-speech

# DO:
# sudo apt-get install festival xsel sox festvox-ru

# ошибка LTS_Ruleset russian_downcase: no rule matches: LTS_Ruleset: # *here*
# cfg/patches/festival/msu_ru_nsh_lexicon.scm в
# /usr/share/festival/voices/russian/msu_ru_nsh_clunits/festvox/msu_ru_nsh_lexicon.scm

# https://gist.github.com/d9k/f6b7670d61e00840082dbc5d74be53f5

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

running=$(pgrep festival)
TEMPO=1.2
PITCH=-120

#IFS= read var << EOF
#$(foo)
#EOF

#echo "$PIPE_CONTENT"

#stdin=$(cat)
#echo "$stdin"
#
#exit

FILEPATH=$@

if [[ -z "$FILEPATH" ]]; then
  echo "FILEPATH arg required"
  exit
fi

echo "$FILEPATH"
FILENAME=$(basename "${FILEPATH}")

echo "$FILENAME"

#FILECAPTION="${FILENAME%%.*}"
#FILECAPTION=$(echo ${FILENAME/*./})
FILECAPTION=$(echo "${FILENAME}" | sed -r 's/(.+)\..+|(.*)/\1\2/')

if [ -n $running ]
then
    #kill it
    killall festival;killall audsp;killall play;sleep .1;killall play
fi

TEMP_FILE_PATH=$(mktemp)

echo $FILECAPTION > ${TEMP_FILE_PATH}

echo "=== Before fix ==="
cat ${TEMP_FILE_PATH}

${CURRENT_PATH}/win/say-selection-ru-fix-file.sh ${TEMP_FILE_PATH}

echo
echo "=== After fix ==="
cat ${TEMP_FILE_PATH}
echo

MP3_PATH=/tmp/t.mp3

fest_opts="(Parameter.set 'Audio_Method 'Audio_Command)"
fest_opts+="(Parameter.set 'Audio_Required_Rate 11025)\n"
fest_opts+="(Parameter.set 'Audio_Required_Format 'riff)\n"
#fest_opts+="(Parameter.set 'Audio_Command "\""play -q -b 16 -c 1 -e signed-integer -r \$SR -t raw \$FILE tempo ${TEMPO} pitch ${PITCH}"\"")"
fest_opts+="(Parameter.set 'Audio_Command "\""lame --quiet --preset voice \$FILE - >> $MP3_PATH"\"")\n"
fest_opts+="(tts_file \""${TEMP_FILE_PATH}"\" nil)"

echo
echo -e "${fest_opts}"
echo

echo -e "${fest_opts}" | festival --pipe --language russian

#sleep 2

#rm ${TEMP_FILE_PATH}


