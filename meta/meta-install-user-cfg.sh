#!/bin/bash
#Please install zsh first!

META_SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS=`readlink -f ${META_SCRIPTS}/..`
CFG=${SCRIPTS}/cfg
cp ${CFG}/.hgrc ~/
cp ${CFG}/.aliases.light ~/.aliases

ALIASES_LOAD="
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
"

ZSH_ALIASES_LOAD=`cat ${CFG}/.zshrc.add`

echo "${ALIASES_LOAD}" >> ~/.bashrc
echo "${ZSH_ALIASES_LOAD}" >> ~/.zshrc

