#!/bin/bash

nemo "$@" &>/dev/null &
disown
