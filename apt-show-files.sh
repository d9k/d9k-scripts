#!/bin/bash

set -x
dpkg-query -L $@
