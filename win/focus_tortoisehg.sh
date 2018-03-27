#!/bin/bash

#lower => better priority
titles=(
 "TortoiseHg Workbench"
 "SmartGit"
)

name="TortoiseHg Workbench"

for (( ix=${#titles[@]}-1 ; ix>=0 ; ix-- )); do
	echo "checking \"${titles[ix]}\":"
	t=$(wmctrl -lp | grep "${titles[ix]}")
	if [ $? -eq 1 ]; then
		if [ "${ix}" -eq "0" ]; then
      echo 1
			#echo "Last one: starting thg"
			thg --nofork &
		fi
	else
		echo "focusing \"${t}\""
		wmctrl -a "${titles[ix]}"
		break
    fi
done


#t=$(wmctrl -lp | grep "${name}")
#if [ $? -eq 1 ]; then
#    thg --nofork &
#else
#    wmctrl -a "${name}"
#fi
