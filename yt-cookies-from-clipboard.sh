#!/bin/bash

COOKIES_FILE=$HOME/temp/chrome-yt-cookies/chrome-yt-cookies.txt
REQUIRED_COOKIES_HEADER="Netscape HTTP Cookie File"

function echoerr {
  printf "%s\n" "$*" >&2;
}

COOKIES_CONTENT="$(xclip -selection clipboard -o)"

if [[ -z "$COOKIES_CONTENT" ]]; then
  echoerr "Error: Clipboard is empty"
  exit 100
fi

if ! printf "%s" "$COOKIES_CONTENT" | grep --quiet --fixed-strings "$REQUIRED_COOKIES_HEADER"; then
  echoerr "Error: Clipboard doesn't contain $REQUIRED_COOKIES_HEADER header"
  exit 150
fi

if [[ ! -d "$(dirname "$COOKIES_FILE")" ]]; then
  echoerr "Error: Directory $(dirname "$COOKIES_FILE") doesn't exist"
  exit 200
fi

printf "%s" "$COOKIES_CONTENT" > "$COOKIES_FILE"

echo "Saved $COOKIES_FILE"
ls -l "$COOKIES_FILE"

if [[ -z "$YTDLP_COOKIES_FILE" ]]; then
  EXPORT_CMD="export YTDLP_COOKIES_FILE=\"$COOKIES_FILE\""
  printf "%s" "$EXPORT_CMD" | xclip -selection clipboard
  echo
  echo "YTDLP_COOKIES_FILE environment variable is empty!"
  echo "The command to init variable was copied to clipboard:"
  echo "$EXPORT_CMD"
  echo "Paste and run it to export env variable!"
fi
