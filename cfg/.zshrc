# Path to your Oh My Zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# plugins=()

# Doesn't work
# plugins+=(zsh-better-npm-completion)

#plugins+=(zsh-npm-scripts-autocomplete)

# source $ZSH/oh-my-zsh.sh

# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt adam1

# for prompt setup see "function precmd" below

# Used for inspiration:
# https://github.com/ricbra/zsh-config/blob/master/zshrc

# ability to comment out broken command with `#` to run it later from history
setopt interactivecomments
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt histignorealldups

# Appends every command to the history file once it is executed
setopt inc_append_history

# Reloads the history whenever you use it
setopt share_history

# Switching directories for lazy people
setopt autocd
# See: http://zsh.sourceforge.net/Intro/intro_6.html
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

# If the argument to a cd command (or an implied cd with the AUTO_CD option set)
# is not a directory, and does not begin with a slash, try to expand the
# expression as if it were preceded by a '~'
#setopt cdablevars

# Try to make the completion list smaller (occupying less lines) by printing
# the matches in columns with different widths
#setopt listpacked


# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word
setopt alwaystoend

# for urls with "?"
# https://superuser.com/questions/982110/how-can-i-disable-globbing-for-url-arguments-in-zsh
setopt NO_NOMATCH

# https://github.com/robbyrussell/oh-my-zsh/issues/449
# git HEAD^ correct
#setopt no_nomatch

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

INC_APPEND_HISTORY=1

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
# unicode chars support, see https://stackoverflow.com/a/16509364/1760643
fast_chr() {
    local __octal
    local __char
    printf -v __octal '%03o' $1
    printf -v __char \\$__octal
    REPLY=$__char
}

# usage: unichr 0x2505
function unichr {
    local c=$1    # Ordinal of char
    local l=0    # Byte ctr
    local o=63    # Ceiling
    local p=128    # Accum. bits
    local s=''    # Output string

    (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

    while (( c > o )); do
        fast_chr $(( t = 0x80 | c & 0x3f ))
        s="$REPLY$s"
        (( c >>= 6, l++, p += o+1, o>>=1 ))
    done

    fast_chr $(( t = p | c ))
    echo -n "$REPLY$s"
}

function save_current_dir_to_history {
  DIR_HISTORY_ERRORS_PATH=~/.dir-history-errors

  if [ ! $(command -v sponge) ]; then
    echo "sponge is not installed (run sudo apt install moreutils)" >> "$DIR_HISTORY_ERRORS_PATH"
    return;
  fi

  # save current dir to history
  CURRENT_DIR=$(pwd)
  DIR_HISTORY_PATH=~/.dir-history

  # install sponge from moreutils
  echo "${CURRENT_DIR}" >> "$DIR_HISTORY_PATH"
  tail -n 100 "$DIR_HISTORY_PATH" | sponge "$DIR_HISTORY_PATH"
  # remove duplicates
  cat "$DIR_HISTORY_PATH" | tac | awk '!seen[$0]++' | tac | sponge "$DIR_HISTORY_PATH"
}

PROMPT_SEP=' '

function prompt_part_git {
  PROMPT_PART_GIT=

  PUSH_REQUIRED=$(push-required)
  COMMIT_REQUIRED=$(commit-required)

  if [[ -n "${PUSH_REQUIRED}" ]]; then
    PROMPT_PART_GIT="${PROMPT_PART_GIT}${PROMPT_SEP}"$'%B%F{red}push%b '
  fi

  if [[ -n "${COMMIT_REQUIRED}" ]]; then
    PROMPT_PART_GIT="${PROMPT_PART_GIT}${PROMPT_SEP}"$'%B%F{yellow}commit%b '
  fi

  # check git branch differs from default
  # set default branch: git config user.defaultbranch "product/els/48_portfolio_webinar3_theme2"
  if [[ "$(get-repo-type)" == "git" ]]; then

    GIT_NAME_REQUIRED=

    if [[ -z "$(git config --local --get user.name)" ]]; then
      GIT_NAME_REQUIRED=1
    fi

    if [[ -z "$(git config --local --get user.email)" ]]; then
      GIT_NAME_REQUIRED=1
    fi

    # if [[ -n "$GIT_NAME_REQUIRED" ]]; then
    #  PROMPT_PART_GIT="${PROMPT_PART_GIT}${PROMPT_SEP}"$'%F{yellow}name?%b '
    # fi

    GIT_BRANCH_DEFAULT="$(git config --get user.defaultbranch)"
    GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    GIT_BRANCH_ICON="${ICON_BRANCH}"

    if [[ "${GIT_BRANCH}" == "HEAD" ]]; then
      GIT_TAG=$(git describe --exact-match 2>/dev/null)

      if [[ -z "$GIT_TAG" ]]; then
        GIT_TAG=$(git describe --tags 2>/dev/null)
      fi

      if [[ -n "${GIT_TAG}" ]]; then
        GIT_BRANCH="${GIT_TAG}"
        GIT_BRANCH_ICON="${ICON_TAG}"
      fi
    fi

    if [[ "${GIT_BRANCH_DEFAULT}" != "${GIT_BRANCH}" ]]; then
      PROMPT_PART_GIT="${PROMPT_PART_GIT}${PROMPT_SEP}"$'%F{cyan}'"${GIT_BRANCH_ICON}  ${GIT_BRANCH} "
    fi
  fi

  echo "$PROMPT_PART_GIT"
}

function prompt_part_jobs {
  JOBS_COUNT=$(jobs | wc -l)

  # -1 for newline character
  # let "JOBS_COUNT=JOBS_COUNT-1"

  if [[ "$JOBS_COUNT" -gt 0 ]]; then
    echo $'%F{yellow}'" jobs: $JOBS_COUNT "
  fi
}

function prompt_part_node {
  PROMPT_NODE_PART=

  # nvm: check if not default node version
  if [[ -n "${NODE_VERSION_DEFAULT}" ]]; then
    NODE_VERSION="$(node -v)"
    if [[ "${NODE_VERSION_DEFAULT}" != "${NODE_VERSION}" ]]; then
      PROMPT_NODE_PART="${PROMPT_NODE_PART}${PROMPT_SEP}"$'%F{yellow}'"node_${NODE_VERSION} "
    fi
  fi

  # nvm: check if .nvmrc file is present
  if [[ -f ".nvmrc" ]]; then
    PROMPT_NODE_PART="${PROMPT_NODE_PART}${PROMPT_SEP}"$'%B%F{yellow}nvmrc%b '
  fi

  echo "$PROMPT_NODE_PART"
}

export ICON_BRANCH=$(unichr 0x2387)
export ICON_THREE_DOTS=$(unichr 0x2026)
export ICON_TWO_DOTS=$(unichr 0x2025)
export ICON_TAG=$(unichr 0x1F3F7)

OS_NAME=$(cat /etc/os-release | grep "^NAME=" | cut -d\" -f2)

# prompt setup:
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects
# %B (%b) - Start (stop) boldface mode.
# %F (%f) - Start (stop) using a different foreground colour
# %K (%k) - Start (stop) using a different bacKground colour
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# %d - Current working directory
# %~ - Current working directory ommitting $HOME
# %m - The hostname up to the first ‘.’
# see also http://aperiodic.net/phil/prompt/
# see unicode table: https://unicodelookup.com/
function precmd {
  CURRENT_TIME=$(date +%H:%M)

  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  #PROMPT_SEP='%F{blue}| %f'
  PROMPT_START='%F{blue}# %f'
  PROMPT_END=''

  #PROMPT="${PROMPT_START}"$'%B%F{green}%~%b ' # current path
  PROMPT="${PROMPT_START}"$'%B%F{blue}%~%b ' # current path
  PROMPT="${PROMPT}${PROMPT_SEP}"$'%F{white}'"${CURRENT_TIME} "

  PROMPT_PART_GIT=$(prompt_part_git)

  PROMPT="${PROMPT}${PROMPT_PART_GIT}"

  PROMPT_PART_NODE=$(prompt_part_node)
  PROMPT_PART_JOBS=$(prompt_part_jobs)

  PROMPT="${PROMPT}${PROMPT_PART_NODE}${PROMPT_PART_JOBS}"

  # user and computer name
  _USER=$USER

  if [[ "$_USER" == "komarov" ]]; then
    _USER="k${ICON_TWO_DOTS}"
  fi

  COMPUTER_NAME_OUTPUT="$COMPUTER_NAME"
  COMPUTER_NAME_COLOR=$'%F{blue}'

  if [[ "$OS_NAME" == "Arch Linux" ]]; then
    COMPUTER_NAME_OUTPUT="arch"
    COMPUTER_NAME_COLOR=$'%B'$'%F{cyan}'
    HISTFILE=~/.zsh_history_arch
  fi

  # (%n is $USER)
  PROMPT="${PROMPT}${PROMPT_SEP}${COMPUTER_NAME_COLOR}$_USER@${COMPUTER_NAME_OUTPUT} "
  PROMPT="${PROMPT}${PROMPT_END}"$'\n%F{blue}> %b%f%k'
  #PROMPT="${PROMPT}"

  save_current_dir_to_history
}

#PROMPT="%K{blue}%n@%m%k %B%F{green}%51<...<%~%} \n %F{white} %# %b%f%k"

# TRAPEXIT() {
#    pwd > $HOME/.lastdirectory
# }

TRAPEXIT() {
    pwd > $HOME/.lastdirectory
}

current-zsh-command-copy-to-xclip() {
    zle kill-buffer
    print -rn -- $CUTBUFFER | xclip -selection c
    RBUFFER=$CUTBUFFER
    zle end-of-line;
    command -v tmux &>/dev/null && tmux display-message "current zsh command was copied to clipboard" >/dev/null
};

zle -N current-zsh-command-copy-to-xclip

bindkey "^K" current-zsh-command-copy-to-xclip

# This loads node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm use default > /dev/null

# `npm install --cli ...` modules work globally
export NODE_PATH="$NVM_DIR/node_modules"

# Awesome tool that highlights your terminal commands red or green telling you if they are valid as you are typing them. Requires zsh.
ZSH_SYNTAX_HIGHLIGHTING_SCRIPT_PATH=/home/d9k/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# see http://naxoc.net/2014/02/02/syntax-highlighting-commands-with-zsh/
# see https://github.com/zsh-users/zsh-syntax-highlighting

if [[ -f "${ZSH_SYNTAX_HIGHLIGHTING_SCRIPT_PATH}" ]]; then
  source /home/d9k/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#ZSH_HIGHLIGHT_PATTERNS+=('#*' 'fg=yellow,bg=white')
#ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=magenta'

# default comments are black on blank!
ZSH_HIGHLIGHT_STYLES[comment]='fg=magenta,dimmed'

# http://zsh.sourceforge.net/Intro/intro_11.html
# https://unix.stackexchange.com/questions/79897/how-can-i-use-bindkey-to-run-a-script/226062

# alt+u: up one folder
bindkey -s '\eu' 'cd ..\n'
# alt+l: list files
bindkey -s '\el' 'ls -lh\n'
# alt+s: tig status
bindkey -s '\es' 'st\n'
# alt+g: tig
bindkey -s '\eg' 'tig\n'
# alt+r: branch (alt+b bound to "one word back")
bindkey -s '\er' 'branch\n'

alias default_audio_player=smplayer
alias default_image_viewer=gpicview
alias default_mail_viewer=thunderbird
alias default_office_editor=libreoffice
alias default_pdf_viewer=zathura-fix
alias default_markdown_editor=obsidian-open
#alias default_text_editor=ta
alias default_text_editor=nvim
alias default_torrent_app=qbittorrent
alias default_video_player=smplayer
alias default_windows_emulator=wine
alias default_gba_emulator=mgba-qt
alias -- gba-emulator=mgba-qt

alias alternative_pdf_viewer=xreader

# File extension open default
alias -s aliases=default_text_editor
alias -s csv=default_office_editor
alias -s xls=default_office_editor
alias -s xlsx=default_office_editor
alias -s doc=default_office_editor
alias -s docx=default_office_editor
alias -s exe=wine
alias -s gif=default_image_viewer
alias -s jpeg=default_image_viewer
alias -s jpg=default_image_viewer
alias -s eml=default_mail_viewer
alias -s gba=default_gba_emulator
alias -s conf=default_text_editor
alias -s ideavimrc=default_text_editor
alias -s ini=default_text_editor
#alias -s js=default_text_editor
alias -s json=default_text_editor
alias -s md=default_markdown_editor
alias -s mp3=default_audio_player
alias -s mov=default_video_player
alias -s mp4=default_video_player
alias -s mkv=default_video_player
alias -s pdf=default_pdf_viewer
alias -s gitignore=default_text_editor
alias -s php=default_text_editor
alias -s png=default_image_viewer
alias -s tigrc=default_text_editor
alias -s torrent=default_torrent_app
alias -s txt=default_text_editor
alias -s vimrc=default_text_editor
alias -s zshrc=default_text_editor

alias -s webm=default_video_player
alias -s mkv=default_video_player

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# [ -f ~/.nix-profile/etc/profile.d/nix.sh ] && source ~/.nix-profile/etc/profile.d/nix.sh

# https://stackoverflow.com/questions/14177700/copy-current-command-at-bash-prompt-to-clipboard
Y() {} # you'll want this so that you don't get a command unrecognized error

preexec() {
  tmp="";
  if [ "${1:0:1}" = "Y" ] && [ "${1:1:1}" = " " ] && [ "${1:2:1}" != " " ]; then
    for (( i=2; i<${#1}; i++ )); do
      tmp="${tmp}${1:$i:1}";
    done
    echo "$tmp" | xclip -selection clipboard;
  fi
}

source_if_exists() { SRC="$1"
  if [[ -f "$SRC" ]]; then
    source "$SRC"
  fi
}

# https://velociraptor.run/ - The script runner for Deno
if [[ -n $(command -v vr) ]]; then
  source <(vr completions zsh) > /dev/null
fi

# https://github.com/rvm/ubuntu_rvm
source_if_exists /etc/profile.d/rvm.sh

source_if_exists ~/scripts/cfg/zsh-submodules/zsh-yarn-completions/zsh-yarn-completions.plugin.zsh
[[ "$PATH" == *"$HOME/bin:"* ]] || export PATH="$HOME/bin:$PATH"
! { which werf | grep -qsE "^/home/d9k/.trdl/"; } && [[ -x "$HOME/bin/trdl" ]] && source $("$HOME/bin/trdl" use werf "1.2" "stable")

# bun completions
[ -s "/home/d9k/.bun/_bun" ] && source "/home/d9k/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bum
export BUM_INSTALL="$HOME/.bum"
export PATH="$BUM_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/d9k/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# vim mode
# https://github.com/jeffreytse/zsh-vi-mode - A better and friendly vi(vim) mode plugin for ZSH.
export ZSH_VIM_MODE_PLUGIN_PATH="/home/d9k/.zsh-vi-mode/zsh-vi-mode.plugin.zsh"
export ZSH_AUTOLOAD_VI_MODE=1

alias cbread='xclip -selection c'
alias cbprint='xclip -o -selection clipboard'

function zsh_vi_mode_enable {
    source "$ZSH_VIM_MODE_PLUGIN_PATH"

  #  zvm_vi_yank () {
  #	  zvm_yank
  #  	printf %s "${CUTBUFFER}" | xclip -sel c
  #	  zvm_exit_visual_mode
  #  }

    # https://github.com/jeffreytse/zsh-vi-mode/issues/19#issuecomment-1268057812

    my_zvm_vi_yank() {
      zvm_vi_yank
      echo -en "${CUTBUFFER}" | cbread
    }

    my_zvm_vi_delete() {
      zvm_vi_delete
      echo -en "${CUTBUFFER}" | cbread
    }

    my_zvm_vi_change() {
      zvm_vi_change
      echo -en "${CUTBUFFER}" | cbread
    }

    my_zvm_vi_change_eol() {
      zvm_vi_change_eol
      echo -en "${CUTBUFFER}" | cbread
    }

    my_zvm_vi_put_after() {
      CUTBUFFER=$(cbprint)
      zvm_vi_put_after
      zvm_highlight clear # zvm_vi_put_after introduces weird highlighting for me
    }

    my_zvm_vi_put_before() {
      CUTBUFFER=$(cbprint)
      zvm_vi_put_before
      zvm_highlight clear # zvm_vi_put_before introduces weird highlighting for me
    }

    zvm_after_lazy_keybindings() {
      zvm_define_widget my_zvm_vi_yank
      zvm_define_widget my_zvm_vi_delete
      zvm_define_widget my_zvm_vi_change
      zvm_define_widget my_zvm_vi_change_eol
      zvm_define_widget my_zvm_vi_put_after
      zvm_define_widget my_zvm_vi_put_before

      zvm_bindkey visual 'y' my_zvm_vi_yank
      zvm_bindkey visual 'd' my_zvm_vi_delete
      zvm_bindkey visual 'x' my_zvm_vi_delete
      zvm_bindkey vicmd  'C' my_zvm_vi_change_eol
      zvm_bindkey visual 'c' my_zvm_vi_change
      zvm_bindkey vicmd  'p' my_zvm_vi_put_after
      zvm_bindkey vicmd  'P' my_zvm_vi_put_before
    }

    # Fix alt+.
    # [alt + . in insert mode doesn't substitute to last argument! · Issue #287 · jeffreytse/zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode/issues/287)
    function append-last-word { ((++CURSOR)); zle insert-last-word; }
    zle -N append-last-word
    bindkey -M vicmd '\e.' append-last-word

    # Insert mode
    bindkey -M viins '\e.' insert-last-word
}

if [[ -f "$ZSH_VIM_MODE_PLUGIN_PATH" ]]; then
  if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    if [[ -n "$ZSH_AUTOLOAD_VI_MODE" ]]; then
      zsh_vi_mode_enable
    fi
  fi # check not VSCode
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/d9k/.lmstudio/bin"
# End of LM Studio CLI section

# Fix Home / End keys on Arch Linux distrobox container
# https://stackoverflow.com/questions/8638012/fix-key-settings-home-end-insert-delete-in-zshrc-when-running-zsh-in-terminat
# `od -c` to detect key codes
function keyboard_fix_home_end_in_zsh {
  bindkey  "^[[1~"   beginning-of-line
  bindkey  "^[[4~"   end-of-line
}

[ -s "${HOME}/.g/env" ] && \. "${HOME}/.g/env"  # g shell setup

