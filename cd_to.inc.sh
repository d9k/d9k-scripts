#!/bin/bash

# This script
# must be sourced at ~/.zshrc
#
# and requires
# 1) installed https://github.com/d9k/cli-select
#
# 2) the use of
# `save_current_dir_to_history()`
# which saves current dir to ~/.dir-history
# and must be called in the `precmd()` hook of zsh.
#
# see:
# https://github.com/d9k/d9k-scripts/blob/master/cfg/.zshrc

function cd_to {
  TO=$(tac ~/.dir-history | grep --line-regexp --invert-match "$(pwd)" | cli-select -q "Change dir to:")

  #echo "$TO"

  if [[ -n "$TO" ]]; then
    #echo "Changing"
    cd "$TO"
  fi
}

