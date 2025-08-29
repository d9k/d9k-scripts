#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function echoerr {
  printf "%s\n" "$*" >&2;
}

# https://unix.stackexchange.com/questions/467524/open-file-from-history-in-zathura
SELECTION=$(sh -c "cat ~/.local/share/zathura/history | grep -Po '\[\K[^\]]*' | grep -v '\=\$' | tac | dmenu -l 40")

if [[ -z "$SELECTION" ]]; then
  echoerr "Nothing selected! Exitting"
  exit
fi

# https://rodrigo.morales.pe/2025/02/18/compile-zathura-0-5-11-in-ubuntu-24-04-lts/
# LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu ZATHURA_PLUGINS_PATH=/usr/local/lib/x86_64-linux-gnu /usr/local/bin/zathura --mode fullscreen "$SELECTION"

"$SCRIPT_DIR/zathura-fix" "$SELECTION"
