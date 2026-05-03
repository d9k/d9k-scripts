#!/bin/bash

SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# human-readable conditions by qzb (https://github.com/qzb/is.sh)
source "$SCRIPT_DIR/is"

START_COMPRESSING_IF_SIZE_EXCEEDS_KB=800
START_COMPRESSING_IF_WIDTH_EXCEEDS_PX=1920
START_COMPRESSING_IF_HEIGHT_EXCEEDS_PX=1080
START_COMPRESSING_IF_TOTAL_PIXELS_EXCEED=$((START_COMPRESSING_IF_WIDTH_EXCEEDS_PX * START_COMPRESSING_IF_HEIGHT_EXCEEDS_PX))
QUALITY=94

function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME FILE_PATH"
  exit "$EXIT_CODE"
}

function file_size_kb { FILE_PATH="$1";
  du -k "$FILE_PATH" | cut -f1
}

function get_image_dimensions { IMAGE_PATH="$1";
  local width height
  width=$(mediainfo --Output='Image;%Width%' "$IMAGE_PATH")
  height=$(mediainfo --Output='Image;%Height%' "$IMAGE_PATH")
  echo "$width" "$height"
}

function get_image_quality { IMAGE_PATH="$1";
  jhead "$IMAGE_PATH" 2>/dev/null | grep "JPEG Quality" | awk '{print $NF}' || echo "unknown"
}

FILE_REL_PATH="$1"

if [[ -z "$FILE_REL_PATH" ]]; then
  help_exit
fi

if is not file "$FILE_REL_PATH"; then
  echoerr "Error: \"$FILE_REL_PATH\" is not file"
  exit 150
fi

FILE_ABS_PATH=$(readlink -f "$FILE_REL_PATH")
FILE_DIR_PATH=$(dirname "$FILE_ABS_PATH")
FILE_NAME_WITH_EXT=$(basename "$FILE_REL_PATH")
HISTORY_FILE="${FILE_DIR_PATH}/.compress-images-history.json"

FILE_EXTENSION=$(echo "$FILE_NAME_WITH_EXT" | rev | cut -f 1 -d '.' | rev)
FILE_NAME_NO_EXT=$(echo "$FILE_NAME_WITH_EXT" | sed -e "s/\.${FILE_EXTENSION}$//g")

if ! echo "$FILE_EXTENSION" | grep -qi -E 'jpg|jpeg'; then
  echoerr "Error: extension .$FILE_EXTENSION is not supported. Only jpg|jpeg allowed"
  exit 200
fi

if ! command -v jq &> /dev/null; then
  echoerr "jq command could not be found. Install jq first"
  exit 450
fi

# Exit if compress history contains info about current image file
if [[ -f "$HISTORY_FILE" ]]; then
  EXISTING_ENTRY=$(jq --arg name "$FILE_NAME_WITH_EXT" '.[] | select(.file_name == $name)' "$HISTORY_FILE" 2>/dev/null)
  if [[ -n "$EXISTING_ENTRY" ]]; then
    echo "File \"$FILE_NAME_WITH_EXT\" already exists in compression history. Skipping."
    exit 250
  fi
fi

FILE_SIZE_KB=$(file_size_kb "$FILE_ABS_PATH")

# Skip if file size and total pixels are small enough (no need to compress)
if [ "$FILE_SIZE_KB" -lt "$START_COMPRESSING_IF_SIZE_EXCEEDS_KB" ]; then
  echo "Skipping compression: file size is just ${FILE_SIZE_KB}kb (< ${START_COMPRESSING_IF_SIZE_EXCEEDS_KB}kb)"
  exit
fi

# Get original dimensions and quality for skip check
read -r WIDTH_BEFORE HEIGHT_BEFORE < <(get_image_dimensions "$FILE_ABS_PATH")
TOTAL_PIXELS_BEFORE=$((WIDTH_BEFORE * HEIGHT_BEFORE))

if [ "$TOTAL_PIXELS_BEFORE" -lt "$START_COMPRESSING_IF_TOTAL_PIXELS_EXCEED" ]; then
  echo "Skipping compression: size is just ${WIDTH_BEFORE}x${HEIGHT_BEFORE} px (< ${START_COMPRESSING_IF_WIDTH_EXCEEDS_PX}x${START_COMPRESSING_IF_HEIGHT_EXCEEDS_PX} px)"
  exit
fi

if ! command -v convert &> /dev/null; then
  echoerr "convert (imagemagick) command could not be found. Install imagemagick first"
  exit 300
fi

if ! command -v mozjpeg &> /dev/null; then
  echoerr "mozjpeg command could not be found. Do \"npm install --global mozjpeg\" first"
  exit 350
fi

if ! command -v mediainfo &> /dev/null; then
  echoerr "mediainfo command could not be found. Install mediainfo first"
  exit 400
fi

if ! command -v sponge &> /dev/null; then
  echoerr "sponge (moreutils) command could not be found. Install moreutils first"
  exit 500
fi

if ! command -v jhead &> /dev/null; then
  echoerr "jhead command could not be found. Install jhead first"
  exit 550
fi

QUALITY_BEFORE=$(get_image_quality "$FILE_ABS_PATH")

RESIZE_PATH="${FILE_DIR_PATH}/${FILE_NAME_NO_EXT}.resize.png"

# Resize image with imagemagick using lanczos3 filter (reduce by 2x)
convert "$FILE_ABS_PATH" -filter Lanczos -resize 50%x50% "$RESIZE_PATH"

# Compress with mozjpeg back to original file
mozjpeg -quality "$QUALITY" -outfile "$FILE_ABS_PATH" "$RESIZE_PATH"

# Remove temporary resize file
rm "$RESIZE_PATH" &> /dev/null

# Get compressed dimensions, size and quality
read -r WIDTH_AFTER HEIGHT_AFTER < <(get_image_dimensions "$FILE_ABS_PATH")
QUALITY_AFTER=$(get_image_quality "$FILE_ABS_PATH")
OUTPUT_FILE_SIZE_KB=$(file_size_kb "$FILE_ABS_PATH")

PERCENT_DELTA_RAW=$(echo "($FILE_SIZE_KB-$OUTPUT_FILE_SIZE_KB)/$FILE_SIZE_KB*100" | bc -l)
PERCENT_DELTA=$(printf %.0f "$PERCENT_DELTA_RAW")
TOTAL_PIXELS_AFTER=$((WIDTH_AFTER * HEIGHT_AFTER))
echo "compression file result: (-${PERCENT_DELTA}%: ${OUTPUT_FILE_SIZE_KB}kb <- ${FILE_SIZE_KB}kb, ${WIDTH_AFTER}x${HEIGHT_AFTER} px <- ${WIDTH_BEFORE}x${HEIGHT_BEFORE} px)"

# Get current timestamp in ISO 8601 format
COMPRESSED_AT=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")

# Create new history entry
NEW_ENTRY=$(jq -n \
  --arg file_name "$FILE_NAME_WITH_EXT" \
  --arg compressed_at "$COMPRESSED_AT" \
  --arg size_before_kb "$FILE_SIZE_KB" \
  --arg size_after_kb "$OUTPUT_FILE_SIZE_KB" \
  --arg width_before_px "$WIDTH_BEFORE" \
  --arg width_after_px "$WIDTH_AFTER" \
  --arg height_before_px "$HEIGHT_BEFORE" \
  --arg height_after_px "$HEIGHT_AFTER" \
  --arg quality_before "$QUALITY_BEFORE" \
  --arg quality_after "$QUALITY_AFTER" \
  '{
    file_name: $file_name,
    compressed_at: $compressed_at,
    size_before_kb: ($size_before_kb | tonumber),
    size_after_kb: ($size_after_kb | tonumber),
    width_before_px: ($width_before_px | tonumber),
    width_after_px: ($width_after_px | tonumber),
    height_before_px: ($height_before_px | tonumber),
    height_after_px: ($height_after_px | tonumber),
    quality_before: ($quality_before | tonumber),
    quality_after: ($quality_after | tonumber)
  }')

# Initialize history file if it doesn't exist
if [[ ! -f "$HISTORY_FILE" ]]; then
  echo "[]" > "$HISTORY_FILE"
fi

# Append new entry to history using sponge
jq --argjson entry "$NEW_ENTRY" '. += [$entry]' "$HISTORY_FILE" | sponge "$HISTORY_FILE"
