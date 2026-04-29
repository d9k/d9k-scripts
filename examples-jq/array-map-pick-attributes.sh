#!/bin/bash

set -x

cat array-map.json \
  | jq "map({ \
    id, \
    name, \
    created: .attributes.created \
  })"
