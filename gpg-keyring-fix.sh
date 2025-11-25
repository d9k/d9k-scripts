#!/bin/bash

# See also: 
# pass-gpg-ui-cli.sh
# pass-gpg-ui-x.sh

OUT="$HOME/.keyring-fix"

(
  set -x
  sudo killall ssh-agent
  sudo killall gnome-keyring-daemon
  sudo killall pinentry
)

sleep 1

if [[ -n "$SSH_AUTH_SOCK" ]]; then
  echo "Binding to permanent address \$SSH_AUTH_SOCK"
  echo "to bind keyring to random socket run:"
  echo "export SSH_AUTH_SOCK="
  # unix_listener: cannot bind to path : No such file or directory
  # ssh-agent -s -a "$SSH_AUTH_SOCK" > "$OUT"
  SSH_AUTH_SOCK_DIR=$(dirname $SSH_AUTH_SOCK)
  mkdir -p "$SSH_AUTH_SOCK_DIR"
  chmod go-rwx "$SSH_AUTH_SOCK_DIR"
  ( set -x; ssh-agent -s -a $SSH_AUTH_SOCK > "$OUT" )
else
  ( set -x; ssh-agent -s > "$OUT" )
fi

. "$OUT"


printf "export " >> "$OUT"

#gnome-keyring-daemon --replace --components=pkcs11,secrets,ssh >> "$OUT"
gnome-keyring-daemon --replace --components=pkcs11,secrets >> "$OUT"
echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> "$OUT"

echo "$OUT:"
cat "$OUT"

echo
echo "Run"
echo
echo ". \"$OUT\""
echo
echo "in other consoles"
