#!/bin/bash

REPO_TYPE=$(get-repo-type)

if [[ -z "$REPO_TYPE" ]]; then
  echo "Repo not detected"
  exit
fi

#echo "$REPO_TYPE repo detected"

if [ "$REPO_TYPE" == "git" ]; then
  tig status
  exit
fi

if [ "$REPO_TYPE" == "hg" ]; then
  hg status
  exit
fi
