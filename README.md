# d9k scripts

(and config at `/cfg`)

## Installation

Project uses [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

so use

```
git clone --recurse-submodules git@github.com:d9k/d9k-scripts.git
git config --global diff.submodule log
```

to install it.

## Paths with submodules:

* `submodules`
* `cfg/zsh-submodules/*`

## Update submodules after pull

```
git submodule update --init --recursive
```

## Markdown Scripts

- [markdown-append-chapter](./markdown-append-chapter) `[-c|--clipboard] [TARGET_FILENAME]` — Append text fragment from stdin or clipboard to markdown/txt file with fzf selection
- [markdown-commit](./markdown-commit) `[FILE_NAME]` — Commit changed markdown file with auto-generated message from added headers
- [markdown-fix-header](./markdown-fix-header) `[-c|--clipboard] [-f|--force]` — Fix markdown header by detecting URL and generating title via youtube/url processor
- [markdown-from-hh-vacancy.sh](./markdown-from-hh-vacancy.sh) `VACANCY_URL` — Convert hh.ru vacancy page to markdown file
- [markdown-header-from-url](./markdown-header-from-url) `[-c|--copy-to-clipboard] [--link] URL` — Generate markdown header/link from URL metadata (title, author, site, year)
- [markdown-header-from-youtube](./markdown-header-from-youtube) `[--proxy PROXY_URL] [-l|--link] [-c|--copy-to-clipboard] VIDEO_URL` — Generate markdown header/link from YouTube video metadata
- [markdown-headers-added](./markdown-headers-added) `[-s|--short] [FILE_NAME]` — Show headers added to markdown files (git diff) in short or full format
- [markdown-headers-decrease-after-subnote-extract.sh](./markdown-headers-decrease-after-subnote-extract.sh) `FILE_NAME` — Preview and apply header level decrease after subnote extraction
- [markdown-headers.sh](./markdown-headers.sh) `[-n|--line-number] FILE_PATH` — Display markdown headers with optional line numbers from file or vault
- [markdown-image-fileurl](./markdown-image-fileurl) `FILE` — Generate markdown image syntax with file:// URL and copy to clipboard
