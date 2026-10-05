#!/usr/bin/env bash
# Revert the File Explorer item-height patch by restoring the pristine backup.
#
# Restores:
#   /usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js
# from:
#   /usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js.bak-item-height
#
# Env overrides:
#   VS_CODE_MAIN_JS  path to workbench.desktop.main.js
#
# The backup file is kept after restore. Reload/restart VS Code afterwards.
set -euo pipefail

TARGET="${VS_CODE_MAIN_JS:-/usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js}"
BACKUP="${TARGET}.bak-item-height"

if [[ ! -f "$BACKUP" ]]; then
	echo "ERROR: backup not found: $BACKUP" >&2
	echo "       Nothing to revert (was the patch ever applied?)." >&2
	exit 1
fi

if [[ ! -w "$TARGET" ]]; then
	echo "ERROR: target bundle is not writable: $TARGET" >&2
	echo "       Claim ownership first:  sudo chown -R \$(whoami) /usr/share/code" >&2
	exit 1
fi

# Overwrite in place (preserves inode, owner and permissions).
cat "$BACKUP" > "$TARGET"

echo "Reverted: $TARGET"
echo "From:     $BACKUP"
echo "Now reload the VS Code window (or restart) to apply."
