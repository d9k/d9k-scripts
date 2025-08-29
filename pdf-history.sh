#!/bin/bash

# https://unix.stackexchange.com/questions/467524/open-file-from-history-in-zathura
SELECTION=$(sh -c "cat ~/.local/share/zathura/history | grep -Po '\[\K[^\]]*' | grep -v '\=\$' | tac | dmenu -l 40")

if [[ -n "$SELECTION" ]]; then
  zathura "$SELECTION"
fi


