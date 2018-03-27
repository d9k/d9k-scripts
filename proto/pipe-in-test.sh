#!/bin/bash
# see http://stackoverflow.com/questions/2746553/bash-script-read-values-from-stdin-pipe
stdin=$(cat)
echo "${stdin}" > ~/test.txt