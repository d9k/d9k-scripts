#!/bin/bash

idea "$@" &>/dev/null &
disown
