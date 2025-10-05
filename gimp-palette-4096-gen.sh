#!/bin/bash

# https://www.1728.org/colrchr5.htm

PALETTE_NAME="Nokia N-Gage (4096)"

R=0
G=0
B=0

R_255_printed=
G_255_printed=
B_255_printed=

STEP=16

PRINT_COLOR_LAST=

function print_color() {
  PRINT_COLOR_NEW=$(printf "%3s %3s %3s" $R $G $B)

  if [[ "$R" == "$R_255_printed" ]]; then
    R_255_printed=1
  fi

  if [[ "$R" == "$R_255_printed" ]]; then
    G_255_printed=1
  fi

  if [[ "$R" == "$R_255_printed" ]]; then
    B_255_printed=1
  fi

  if [[ "$PRINT_COLOR_NEW" != "$PRINT_COLOR_LAST" ]]; then
    echo "$PRINT_COLOR_NEW"
  fi

  PRINT_COLOR_LAST="$PRINT_COLOR_NEW"
}

while [ "$R" -le "255" ]; do
  print_color

  while [ "$G" -le "255" ]; do
    print_color

    while [ "$B" -le "255" ]; do
      print_color
      B=`expr $B + $STEP`
    done # B

    if [[ -z "$B_255_printed" ]]; then
      B=255
      print_color
    fi

    B=0
    B_255_printed=

    G=`expr $G + $STEP`
  done # G

  if [[ -z "$G_255_printed" ]]; then
    G=255
    print_color
  fi

  G=0
  G_255_printed=

  R=`expr $R + $STEP`
done # R

if [[ -z "$R_255_printed" ]]; then
  R=255
  print_color
fi


