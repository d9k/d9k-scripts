#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$SCRIPT_DIR/hw-keyboard-swap-caps-lock-esc.sh
$SCRIPT_DIR/hw-keyboard-fix-repeat-rate.sh
