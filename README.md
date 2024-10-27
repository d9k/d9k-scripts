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
