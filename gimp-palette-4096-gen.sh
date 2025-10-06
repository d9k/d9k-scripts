#!/bin/bash

PALETTE_NAME="Nokia N-Gage (4096 colors)"
OUTPUT_FILE_NAME="Nokia_N-Gage_4096_colors"

R=0
G=0
B=0

R_255_printed=
G_255_printed=
B_255_printed=

STEP=17

PRINT_COLOR_LAST=

# SKIP_COLOR_LEVEL=240
SKIP_COLOR_LEVEL=

OUTPUT_FILE_PATH="./$OUTPUT_FILE_NAME.gpl"
OUTPUT_FILE_PATH_ABS=$(readlink -f "$OUTPUT_FILE_PATH")

function echoerr {
  printf "%s\n" "$*" >&2;
}

function print_color() {
  PRINT_COLOR_NEW=$(printf "%3s %3s %3s" $R $G $B)

  if [[ "$R" == "255" ]]; then
    R_255_printed=1
  fi

  if [[ "$G" == "255" ]]; then
    G_255_printed=1
  fi

  if [[ "$B" == "255" ]]; then
    B_255_printed=1
  fi

  if [[ "$PRINT_COLOR_NEW" == "$PRINT_COLOR_LAST" ]]; then
    return
  fi

  PRINT_COLOR_LAST="$PRINT_COLOR_NEW"

  if [[ "$R" == "$SKIP_COLOR_LEVEL" ]]; then
    return
  fi

  if [[ "$G" == "$SKIP_COLOR_LEVEL" ]]; then
    return
  fi

  if [[ "$B" == "$SKIP_COLOR_LEVEL" ]]; then
    return
  fi

  HEX=$(printf "#%02x%02x%02x" $R $G $B)
  echo "$PRINT_COLOR_NEW" $HEX >> "$OUTPUT_FILE_PATH_ABS"
}

# echo "Used https://www.1728.org/colrchr5.htm for reference"
echo "Used http://www.ficml.org/jemimap/style/color/wheel.html for reference"
echo "Writing palette to file \"$OUTPUT_FILE_PATH_ABS\"..."

# Clearing file contents:
> "$OUTPUT_FILE_PATH_ABS"

echo "GIMP Palette" >> "$OUTPUT_FILE_PATH_ABS"
echo "Name: $PALETTE_NAME" >> "$OUTPUT_FILE_PATH_ABS"
echo "#" >> "$OUTPUT_FILE_PATH_ABS"

while [ ! "$R_255_printed" ]; do
  print_color

  while [ ! "$G_255_printed" ]; do
    print_color

    while [ ! "$B_255_printed" ]; do
      print_color
      B=`expr $B + $STEP`

      if [[ "$B" -gt 255 ]]; then
        B=255
      fi
    done # B

    G=`expr $G + $STEP`
    if [[ "$G" -gt 255 ]]; then
      G=255
    fi

    B=0
    B_255_printed=
  done # G

  R=`expr $R + $STEP`
  if [[ "$R" -gt 255 ]]; then
    R=255
  fi

  G=0
  G_255_printed=
done # R

if [[ -z "$R_255_printed" ]]; then
  R=255
  print_color
fi

echo "Copy the palette file to the GIMP palettes directory, something like \"~/.config/GIMP/3.0/palettes/\" (on Linux)"
