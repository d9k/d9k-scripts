#!/bin/bash

# Constants
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

BASE_URL="https://spb.hh.ru/vacancy"
VACANCIES_HTML_DIR_PATH="/tmp/hh-vacancy-to-markdown"
TEMPORARY_WEBSERVER_PORT=8109

# Functions
function echoerr {
  printf "%s\n" "$*" >&2;
}

function help_exit { EXIT_CODE="$1";
  if [[ -z "$EXIT_CODE" ]]; then
    EXIT_CODE=1
  fi

  echoerr "Usage: $SCRIPT_NAME VACANCY_URL"
  echoerr ""
  echoerr "Example: $SCRIPT_NAME https://spb.hh.ru/vacancy/133807505"
  exit "$EXIT_CODE"
}

function kill_web_server_on_port {
  local port="$1"

  if [[ -z "$port" ]]; then
    echoerr "kill_web_server_on_port: Port is not defined"
    return
  fi

  local pid
  pid=$(lsof -t -sTCP:LISTEN -i :"$port")

  if [[ -z "$pid" ]]; then
    return
  fi

  kill -9 "$pid"
}

function cleanup {
  kill_web_server_on_port "$TEMPORARY_WEBSERVER_PORT"
}

trap cleanup EXIT INT TERM

VACANCY_URL="$1"

if [[ -z "$VACANCY_URL" ]]; then
  help_exit 100
fi

# Extract VACANCY_ID from URL like https://spb.hh.ru/vacancy/133807505
VACANCY_ID=$(echo "$VACANCY_URL" | grep -oP '(?<=/vacancy/)\d+')

if [[ -z "$VACANCY_ID" ]]; then
  echoerr "Could not extract VACANCY_ID from URL: $VACANCY_URL"
  exit 200
fi

VACANCY_RAW_HTML_FILE_PATH="$VACANCIES_HTML_DIR_PATH/${VACANCY_ID}.raw.html"
VACANCY_EXTRACTED_HTML_FILE_PATH="$VACANCIES_HTML_DIR_PATH/${VACANCY_ID}.html"

mkdir -p "$VACANCIES_HTML_DIR_PATH"

wget -q -O "$VACANCY_RAW_HTML_FILE_PATH" "$VACANCY_URL"

if [[ ! -f "$VACANCY_RAW_HTML_FILE_PATH" ]]; then
  echoerr "Failed to download page: $VACANCY_URL"
  exit 300
fi

# Extract the main column container
cat "$VACANCY_RAW_HTML_FILE_PATH" \
  | htmlq --pretty ".bloko-column_container" \
  | htmlq --pretty -r ".noprint" \
  > "$VACANCY_EXTRACTED_HTML_FILE_PATH"

if [[ ! -s "$VACANCY_EXTRACTED_HTML_FILE_PATH" ]]; then
  echoerr "Failed to extract content from HTML"
  exit 400
fi

kill_web_server_on_port "$TEMPORARY_WEBSERVER_PORT"

# Start local temporary web server in background because web-to-markdown can't process file:// protocol URLS:
# https://github.com/nidhi-singh02/mark-it-down
busybox httpd -f -h "$VACANCIES_HTML_DIR_PATH" -p "$TEMPORARY_WEBSERVER_PORT" &
WEB_SERVER_PID=$!
# Wait for server to start
sleep 1

# Check if server started successfully
if ! kill -0 "$WEB_SERVER_PID" 2>/dev/null; then
  echoerr "Failed to start web server"
  exit 500
fi

MARKDOWN_FILE_PATH="$VACANCIES_HTML_DIR_PATH/${VACANCY_ID}.md"
# web-to-markdown "http://127.0.0.1:${TEMPORARY_WEBSERVER_PORT}/${VACANCY_ID}.html" > "$MARKDOWN_FILE_PATH"
$SCRIPT_DIR/web-to-markdown-mod.sh --allow-local --raw "http://127.0.0.1:${TEMPORARY_WEBSERVER_PORT}/${VACANCY_ID}.html" > "$MARKDOWN_FILE_PATH"

if [[ ! -s "$MARKDOWN_FILE_PATH" ]]; then
  echoerr "Failed to convert HTML to markdown"
  exit 600
fi

echoerr "Markdown file created: $MARKDOWN_FILE_PATH"
cat "$MARKDOWN_FILE_PATH"
