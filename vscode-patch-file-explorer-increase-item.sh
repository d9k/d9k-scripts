#!/usr/bin/env bash
# Increase tree item height in the installed VS Code (desktop) bundle.
# Tested with VSCode version 1.134.0
#
# Patches the ITEM_HEIGHT static of two list delegates inside the single
# minified ESM bundle:
#   /usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js
#
#   * ExplorerDelegate (File Explorer)      src/vs/workbench/contrib/files/browser/views/explorerViewer.ts
#   * SearchDelegate     (Search results)    src/vs/workbench/contrib/search/browser/searchResultsView.ts
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
#   * Each substitution must match EXACTLY once; otherwise the script aborts without
#     touching the target, so a changed bundle layout is fail-safe.
#   * checksums in product.json are intentionally NOT updated (VS Code may show
#     "installation appears to be corrupt"; dismiss it or use Fix Checksums).
#   * Reload/restart VS Code after patching.
set -euo pipefail

NEW_HEIGHT="${1:-30}"
TARGET="${VS_CODE_MAIN_JS:-/usr/share/code/resources/app/out/vs/workbench/workbench.desktop.main.js}"
BACKUP="${TARGET}.bak-item-height"

# ---------------------------------------------------------------------------
# Anchors. Both are matched literally (single quotes -> '$' is a plain
# char-class member, no shell expansion). Other ITEM_HEIGHT delegates
# (openEditors / tree / chat) have a different getTemplateId() shape and are
# left untouched.
#
# ExplorerDelegate: getTemplateId() returns a single `<X>.ID` and closes the
#   method+class with `}}`.
# SearchDelegate:   getTemplateId() is an if/else-if chain, so its body opens
#   with `if(`.
# ---------------------------------------------------------------------------
EXPLORER_COUNT_RE='class [[:alnum:]_$]+\{static\{this\.ITEM_HEIGHT=[0-9]+\}getHeight\(o\)\{return [[:alnum:]_$]+\.ITEM_HEIGHT\}getTemplateId\(o\)\{return [[:alnum:]_$]+\.ID\}\}'
EXPLORER_SED_RE='s/(class [[:alnum:]_$]+\{static\{this\.)ITEM_HEIGHT=[0-9]+(\}getHeight\(o\)\{return [[:alnum:]_$]+\.ITEM_HEIGHT\}getTemplateId\(o\)\{return [[:alnum:]_$]+\.ID\}\})/\1ITEM_HEIGHT='"$NEW_HEIGHT"'\2/g'

SEARCH_COUNT_RE='class [[:alnum:]_$]+\{static\{this\.ITEM_HEIGHT=[0-9]+\}getHeight\(o\)\{return [[:alnum:]_$]+\.ITEM_HEIGHT\}getTemplateId\(o\)\{if\('
SEARCH_SED_RE='s/(class [[:alnum:]_$]+\{static\{this\.)ITEM_HEIGHT=[0-9]+(\}getHeight\(o\)\{return [[:alnum:]_$]+\.ITEM_HEIGHT\}getTemplateId\(o\)\{if\()/\1ITEM_HEIGHT='"$NEW_HEIGHT"'\2/g'

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

# Fail-safe: each anchor must be present exactly once BEFORE we touch anything.
count_matches() { grep -oE "$1" "$2" | wc -l | tr -d '[:space:]'; }

EXPLORER_COUNT="$(count_matches "$EXPLORER_COUNT_RE" "$TARGET")"
SEARCH_COUNT="$(count_matches "$SEARCH_COUNT_RE" "$TARGET")"

if [[ "$EXPLORER_COUNT" != "1" ]]; then
	echo "ERROR: expected exactly 1 ExplorerDelegate match, got '$EXPLORER_COUNT'." >&2
	echo "       Bundle layout likely changed; no modifications were made." >&2
	echo "       Inspect: grep -oE 'ITEM_HEIGHT=[0-9]+[^}]*getTemplateId[^}]*}' \"$TARGET\"" >&2
	exit 2
fi

if [[ "$SEARCH_COUNT" != "1" ]]; then
	echo "ERROR: expected exactly 1 SearchDelegate match, got '$SEARCH_COUNT'." >&2
	echo "       Bundle layout likely changed; no modifications were made." >&2
	echo "       Inspect: grep -oE 'ITEM_HEIGHT=[0-9]+[^}]*getTemplateId\(o\)\{if\(' \"$TARGET\"" >&2
	exit 2
fi

TMP="$(mktemp "${TMPDIR:-/tmp}/vscode-item-height.XXXXXX")"
trap 'rm -f "$TMP"' EXIT

# sed -E with back-references: only the numeric height is swapped; minified
# identifiers are preserved. Apply both substitutions in a single pass.
sed -E -e "$EXPLORER_SED_RE" -e "$SEARCH_SED_RE" "$TARGET" > "$TMP"

if [[ ! -s "$TMP" ]]; then
	echo "ERROR: patched output is empty; aborting." >&2
	exit 3
fi

# Overwrite in place (preserves inode, owner and permissions).
cat "$TMP" > "$TARGET"

echo "Patched: ExplorerDelegate.ITEM_HEIGHT = $NEW_HEIGHT"
echo "Patched: SearchDelegate.ITEM_HEIGHT   = $NEW_HEIGHT"
echo "File:    $TARGET"
echo "Now reload the VS Code window (or restart) to apply."
