#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Or , instead of . as fraction part separator if called from shortcut, WTF?!
export LC_ALL=en_US.UTF-8

# scrot --focused '%Y_%m_%d__%H_%M_%S__$wx$h.png' -e 'mv $f ~/screenshots/'
scrot \
    --border \
    --focused '%Y_%m_%d__%H_%M_%S__$wx$h.png' \
    -e 'mv $f ~/screenshots/'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm use default > /dev/null

bash "$SCRIPT_DIR/compress-screenshots.sh" ~/screenshots
