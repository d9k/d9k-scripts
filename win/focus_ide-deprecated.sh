#!/bin/bash

#lower => better priority
titles=(
 "DBeaver"
 "NetBeans IDE 8.2"
 "PyCharm"
 "Nightcode 0"
# "Light Table"
 "ZeroBrane Studio"
 "PhpStorm"
 "IntelliJ IDEA"
 "Android Studio"
 " Atom"
)

for (( ix=${#titles[@]}-1 ; ix>=0 ; ix-- )); do
	echo "checking \"${titles[ix]}\":"
	t=$(wmctrl -lp | grep "${titles[ix]}")
	if [ $? -eq 1 ]; then
		if [ "${ix}" -eq "0" ]; then
      echo 1
			#echo "Last one: starting NetBeans"
			#/bin/bash -c "source /home/d9k/.rvm/scripts/rvm; /home/d9k/netbeans-8.0/bin/netbeans" &
		fi
	else
		echo "focusing \"${t}\""
		wmctrl -a "${titles[ix]}"
		# break
    exit
  fi
done

# no more "PhpStorm" in title, selecting by class

PHPSTORM_WIN_ID=$(wmctrl -lx | grep jetbrains-phpstorm.jetbrains-phpstorm | cut -d " " -f1)

if [[ -n "${PHPSTORM_WIN_ID}" ]]; then
  wmctrl -i -a ${PHPSTORM_WIN_ID}
fi
