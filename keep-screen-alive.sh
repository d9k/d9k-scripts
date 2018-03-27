#!/bin/bash
while :
do
    nice -n 1 xdotool key shift
    nice -n 1 xdotool key shift
    date +%T ## show some sign of life
    sleep 100
done