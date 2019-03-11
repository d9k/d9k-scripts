find $(readlink -f .) -maxdepth 1 -type f -exec bash -c 'echo ${1#*.}' _ {} \; | sort | uniq | grep -v "/"
