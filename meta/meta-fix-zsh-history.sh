#!/bin/bash
cp ~/.zsh_history ~/.zsh_history.old
strings ~/.zsh_history.old > ~/.zsh_history
fc -R ~/.zsh_history
