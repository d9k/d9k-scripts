#!/bin/bash

# [Can I make "git status" show the file size of untracked files? - Stack Overflow](https://stackoverflow.com/questions/54690248/can-i-make-git-status-show-the-file-size-of-untracked-files)

# git status --porcelain | awk '{print $2}' | xargs ls -hs | sort -h
# git status --porcelain | awk '{print $2}' | xargs ls -hl | sort -r -h | awk '{print $5 "\t" $9}'

git -C "$(git rev-parse --show-cdup)" ls-files --other --exclude-standard | tr '\n' '\0' | xargs -0 ls -hs | sort -h
