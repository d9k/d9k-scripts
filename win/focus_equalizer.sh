#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

WINDOW_CLASS="pulseeffects.Pulseeffects"

COMMAND="gio launch /var/lib/flatpak/exports/share/applications/com.github.wwmm.pulseeffects.desktop"

${SCRIPT_DIR}/focus-window-by-class.sh "$WINDOW_CLASS" "$COMMAND"
