#!/bin/bash

#lower => better priority
titles=(
 "pgAdmin III"
 "HeidiSQL "
)

for (( ix=${#titles[@]}-1 ; ix>=0 ; ix-- )); do
	echo "checking \"${titles[ix]}\":"
	t=$(wmctrl -lp | grep "${titles[ix]}")
	if [ $? -eq 1 ]; then
		if [ "${ix}" -eq "0" ]; then
			echo "Last one: starting HeidiSQL"
    	    env WINEPREFIX="/home/d9k/.wine" wine C:\\windows\\command\\start.exe /Unix /home/d9k/.wine/dosdevices/c:/users/Public/Start\ Menu/Programs/HeidiSQL/HeidiSQL.lnk -d local
	fi
	else
		echo "focusing \"${t}\""
		wmctrl -a "${titles[ix]}"
		break
    fi
done