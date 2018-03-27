#!/bin/bash

#lower => better priority
titles=(
 "NetBeans IDE 8.2"
 "IntelliJ IDEA"
 "PyCharm"
 "PhpStorm"
 "Nightcode 0"
# "Light Table"
 "ZeroBrane Studio"
 "Android Studio"
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
		break
    fi
done
