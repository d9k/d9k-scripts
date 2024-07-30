#!/bin/bash

# See also: 
# pass-gpg-ui-cli.sh
# pass-gpg-ui-x.sh

OUT="$HOME/.keyring-fix"

sudo killall ssh-agent
sudo killall gnome-keyring-daemon
sudo killall pinentry

ssh-agent -s > "$OUT"

. "$OUT"


printf "export " >> "$OUT"

#gnome-keyring-daemon --replace --components=pkcs11,secrets,ssh >> "$OUT"
gnome-keyring-daemon --replace --components=pkcs11,secrets >> "$OUT"

echo "$OUT:"
cat "$OUT"

echo
echo "Run"
echo
echo ". \"$OUT\""
echo
echo "in other consoles"
