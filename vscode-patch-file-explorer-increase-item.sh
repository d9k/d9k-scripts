#!/usr/bin/env bash
# Increase File Explorer tree item height in the installed VS Code (desktop) bundle.
#
# Patches ExplorerDelegate.ITEM_HEIGHT inside the single minified ESM bundle:
#   /usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js
#
# Usage:
#   vscode-patch-file-explorer-increase-item.sh [NEW_HEIGHT]
#
#   NEW_HEIGHT  positive integer, default 30 (stock value is 22)
#
# Env overrides:
#   VS_CODE_MAIN_JS  path to workbench.desktop.main.js
#
# Notes:
#   * A pristine backup is created next to the file (.bak-item-height) on first run
#     and never overwritten, so re-running with a different height is safe.
#   * The substitution must match EXACTLY once (that one match is ExplorerDelegate:
#     it is the only delegate whose getTemplateId() returns `<X>.ID` while its
#     getHeight() returns `<same>.ITEM_HEIGHT`). Otherwise the script aborts without
#     touching the target, so a changed bundle layout is fail-safe.
#   * checksums in product.json are intentionally NOT updated (VS Code may show
#     "installation appears to be corrupt"; dismiss it or use Fix Checksums).
#   * Reload/restart VS Code after patching.
set -euo pipefail

NEW_HEIGHT="${1:-30}"
TARGET="${VS_CODE_MAIN_JS:-/usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js}"
BACKUP="${TARGET}.bak-item-height"

# ExplorerDelegate anchor. Matched literally (no shell expansion inside single
# quotes, so '$' is a plain char-class member). Other ITEM_HEIGHT=22 delegates
# (openEditors/tree/chat) differ in getTemplateId()/getHeight() shape and are
# left untouched.
COUNT_RE='class [[:alnum:]_$]+\{static\{this\.ITEM_HEIGHT=[0-9]+\}getHeight\(o\)\{return [[:alnum:]_$]+\.ITEM_HEIGHT\}getTemplateId\(o\)\{return [[:alnum:]_$]+\.ID\}\}'

if ! [[ "$NEW_HEIGHT" =~ ^[0-9]+$ ]] || [[ "$NEW_HEIGHT" -le 0 ]]; then
	echo "ERROR: NEW_HEIGHT must be a positive integer, got: '$NEW_HEIGHT'" >&2
	exit 1
fi

if [[ ! -f "$TARGET" ]]; then
	echo "ERROR: target bundle not found: $TARGET" >&2
	exit 1
fi

if [[ ! -w "$TARGET" ]]; then
	echo "ERROR: target bundle is not writable: $TARGET" >&2
	echo "       Claim ownership first:  sudo chown -R \$(whoami) /usr/share/code" >&2
	exit 1
fi

# Refuse to operate on a huge single-line bundle as if it were text if the user
# piped something odd; sed here streams it fine, but warn on absurd sizes.
SIZE="$(wc -c < "$TARGET")"
if [[ "$SIZE" -lt 100000 ]]; then
	echo "ERROR: target bundle looks too small ($SIZE bytes); wrong file?" >&2
	exit 1
fi

# Backup the pristine file once.
if [[ -e "$BACKUP" ]]; then
	echo "Backup already exists, keeping it: $BACKUP"
else
	cp -p "$TARGET" "$BACKUP"
	echo "Backup created: $BACKUP"
fi

# Fail-safe: exactly one ExplorerDelegate anchor must be present.
COUNT="$(grep -oE "$COUNT_RE" "$TARGET" | wc -l | tr -d '[:space:]')"
if [[ "$COUNT" != "1" ]]; then
	echo "ERROR: expected exactly 1 ExplorerDelegate match, got '$COUNT'." >&2
	echo "       The bundle layout likely changed; no modifications were made." >&2
	echo "       Inspect candidates with:" >&2
	echo "         grep -oE 'ITEM_HEIGHT=[0-9]+[^}]*getTemplateId[^}]*}' \"$TARGET\"" >&2
	exit 2
fi

TMP="$(mktemp "${TMPDIR:-/tmp}/vscode-item-height.XXXXXX")"
trap 'rm -f "$TMP"' EXIT

# sed -E with back-references: only the numeric height is swapped; minified
# identifiers are preserved via \1 and \2. NEW_HEIGHT is spliced in (validated
# as pure digits above).
sed -E 's/(class [[:alnum:]_$]+\{static\{this\.)ITEM_HEIGHT=[0-9]+(\}getHeight\(o\)\{return [[:alnum:]_$]+\.ITEM_HEIGHT\}getTemplateId\(o\)\{return [[:alnum:]_$]+\.ID\}\})/\1ITEM_HEIGHT='"$NEW_HEIGHT"'\2/g' \
	"$TARGET" > "$TMP"

if [[ ! -s "$TMP" ]]; then
	echo "ERROR: patched output is empty; aborting." >&2
	exit 3
fi

# Overwrite in place (preserves inode, owner and permissions).
cat "$TMP" > "$TARGET"

echo "Patched: ExplorerDelegate.ITEM_HEIGHT = $NEW_HEIGHT"
echo "File:    $TARGET"
echo "Now reload the VS Code window (or restart) to apply."
