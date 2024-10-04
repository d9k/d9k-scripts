#!/bin/bash

#lower => better priority
titles=(
 "Okular"
 "xreader"
)

for (( ix=${#titles[@]}-1 ; ix>=0 ; ix-- )); do
	echo "checking \"${titles[ix]}\":"
	t=$(wmctrl -lp | grep "${titles[ix]}")
	if [ $? -eq 1 ]; then
		if [ "${ix}" -eq "0" ]; then
			echo "Not found"
			exit
		fi				
	else
		echo "focusing \"${t}\""
		wmctrl -a "${titles[ix]}"
		break
    fi
done
