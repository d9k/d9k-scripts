#!/bin/bash

webstorm "$@" &>/dev/null &
disown
