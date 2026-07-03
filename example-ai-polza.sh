#!/bin/bash

function echoerr {
  printf "%s\n" "$*" >&2;
}

AUTH_KEY=$(pass services/polza.ai-key2)

if [ -z "$AUTH_KEY" ]; then
  echoerr "No auth key"
  exit 200 
fi

curl -X POST "https://polza.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $AUTH_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-4o",
    "messages": [
      {"role": "system", "content": "Ты полезный ассистент."},
      {"role": "user", "content": "Напиши хайку о программировании"}
    ],
    "temperature": 0.7,
    "max_tokens": 100
  }'
