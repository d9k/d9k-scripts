#!/bin/bash
#https://askubuntu.com/questions/447129/how-to-list-all-the-packages-which-are-installed-from-ppas

for APT in $(find /etc/apt/ -name \*.list); do
  grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" $APT | while read ENTRY ; do
    USER=$(echo $ENTRY | cut -d/ -f4)
    PPA=$(echo $ENTRY | cut -d/ -f5)
    awk '$1 == "Package:" { if (a[$2]++ == 0) print $2; }' /var/lib/apt/lists/*$USER*$PPA*Packages
    done
done
