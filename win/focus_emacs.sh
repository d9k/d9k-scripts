#!/bin/bash

#name="emacs -"
name="emacs@"

t=$(wmctrl -lp | grep "${name}")
if [ $? -eq 1 ]; then
    #emacs gets its environment from parent process

    if [ -f ~/.aliases ]; then
        . ~/.aliases
    fi

    emacs &
else
    wmctrl -a "${name}"
fi
