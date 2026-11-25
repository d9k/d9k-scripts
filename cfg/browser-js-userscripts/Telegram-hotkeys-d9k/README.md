# Telegram hotkeys d9k

Userscript for [web.telegram.org](https://web.telegram.org/) (`main.js`).

It adds instant keyboard shortcuts and a command palette for the most frequent
message operations. Everything works **on the message under the mouse cursor**:
the script simulates a right click on the hovered bubble and picks the item in
Telegram's own context menu, so no message needs to be selected or clicked first.

```
// @match        *://web.telegram.org/*
// @run-at       document-start
// @grant        none
```

It adviced to use something like `warpd` to hover cursor over image.

No Tampermonkey `@grant` is required.

## Keyboard shortcuts

| Keys                | Action                                                            |
| ------------------- | ----------------------------------------------------------------- |
| `Ctrl` + `Alt` + `P` | Open the command palette (same as `Ctrl` + `Alt` + `З` on the Russian layout) |
| `Ctrl` + `Alt` + `C` | **C**opy the message under the cursor                             |
| `Ctrl` + `Alt` + `E` | **E**dit the message under the cursor                             |
| `Ctrl` + `Alt` + `S` | **S**elect the message under the cursor                           |
| `Ctrl` + `Alt` + `R` | **R**epost (open the Forward dialog) for the message under the cursor |
| `Alt` + `Delete`<br>`Ctrl` + `Delete` | **D**elete the message **safely**: copy it first, then delete |
| `Ctrl` + `Alt` + `F` | **F**ocus in-chat search                                          |
| `Alt` + `PageUp`     | Search results: previous                                        |
| `Alt` + `PageDown`   | Search results: next                                            |
| `Alt` + `End`        | Search reset: close results                                   |

## Command palette

`Ctrl` + `Alt` + `P` opens a searchable menu with these commands:

- Focus in-chat search
- Message: copy under mouse cursor
- Message: copy link under mouse cursor
- Message: edit under mouse cursor
- Message: select under mouse cursor
- Message: repost under mouse cursor
- Message: ask chat name to repost
- Message: /!\ DELETE under mouse cursor
- Message: safer delete under mouse cursor

`Message: ask chat name to repost` shows a `window.prompt()` asking for the
target chat name, then forwards the message there and presses Send — fully
automated, which is what the `win/firefox-telegram-repost-to-*.sh` wrappers use.

## Dependencies

Both are already inlined into `main.js` in its `DEPENDENCIES` section:

- [hotkeys-js v3.13.7](https://github.com/jaywcjlove/hotkeys-js) — keyboard shortcuts
- [light-cmd-palette-userscripts 0.1.5](https://github.com/d9k/light-cmd-palette-userscripts/blob/main/dist/commandPalette.iife.js) — the command palette UI

## Notes and caveats

- **You must click inside the page at least once** before any hotkey works.
  This is a Firefox limitation of `hotkeys-js`, and the script logs a warning
  about it on startup.
- The library's default `filter()` drops every shortcut while a form field or a
  `contenteditable` node is focused. On web.telegram.org the message compose box
  is a `contenteditable` div focused almost all the time, so `hotkeys.filter` is
  overridden here to allow shortcuts everywhere except inside the palette itself.
  See [hotkeys-js#filter](https://github.com/jaywcjlove/hotkeys-js#filter).

## Related shell wrappers

The `win/` X11 scripts drive Firefox+Telegram through these hotkeys and
the palette, using `xdotool` and `yad`:

- [`win/firefox-telegram-run-command.sh`](../../../win/firefox-telegram-run-command.sh) — opens the palette and picks a command by name
- [`win/firefox-telegram-message-*.sh`](../../../win/) — copy / copy link / open link / edit / select / repost / delete / safer delete at mouse cursor
- [`win/firefox-telegram-move-to-*-at-mouse-cursor.sh`](../../../win/) — repost + delete the original ("move") into `/save/`, `/later/`, top
- [`win/firefox-telegram-repost-to-*-at-mouse-cursor.sh`](../../../win/) — repost only (no delete), into `/2do/` or any chat

## System commands menu

The wrappers above are also listed in [`win/commands-menu`](../../../win/commands-menu)
(`rofi -dmenu`). It only shows the Telegram-related commands when the
matching window class is focused: `Firefox-Telegram` for this userscript.
