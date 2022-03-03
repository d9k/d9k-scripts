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
setopt cdablevars

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

    if [[ -n "$GIT_NAME_REQUIRED" ]]; then
      PROMPT_PART_GIT="${PROMPT_PART_GIT}${PROMPT_SEP}"$'%F{yellow}name?%b '
    fi

    GIT_BRANCH_DEFAULT="$(git config --get user.defaultbranch)"

    GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    if [[ "${GIT_BRANCH_DEFAULT}" != "${GIT_BRANCH}" ]]; then
      PROMPT_PART_GIT="${PROMPT_PART_GIT}${PROMPT_SEP}"$'%F{cyan}'"${ICON_BRANCH}  ${GIT_BRANCH} "
    fi
  fi

  echo "$PROMPT_PART_GIT"
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
function precmd {
  ICON_BRANCH=$(unichr 0x2387)
  ICON_THREE_DOTS=$(unichr 0x2026)
  ICON_TWO_DOTS=$(unichr 0x2025)
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

  PROMPT="${PROMPT}${PROMPT_PART_NODE}"

  # user and computer name
  _USER=$USER

  if [[ "$_USER" == "komarov" ]]; then
    _USER="k${ICON_TWO_DOTS}"
  fi

  # (%n is $USER)
  PROMPT="${PROMPT}${PROMPT_SEP}"$'%F{blue}'"$_USER@${COMPUTER_NAME} "
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

ZSH_SYNTAX_HIGHLIGHTING_SCRIPT_PATH=/home/d9k/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# see http://naxoc.net/2014/02/02/syntax-highlighting-commands-with-zsh/
# see https://github.com/zsh-users/zsh-syntax-highlighting

if [[ -f "${ZSH_SYNTAX_HIGHLIGHTING_SCRIPT_PATH}" ]]; then
  source /home/d9k/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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
alias default_pdf_viewer=xreader
alias default_text_editor=ta
alias default_torrent_app=qbittorrent
alias default_video_player=smplayer


# File extension open default
alias -s aliases=default_text_editor
alias -s csv=default_office_editor
alias -s doc=default_office_editor
alias -s docx=default_office_editor
alias -s gif=default_image_viewer
alias -s jpeg=default_image_viewer
alias -s jpg=default_image_viewer
alias -s eml=default_mail_viewer
alias -s ini=default_text_editor
#alias -s js=default_text_editor
alias -s json=default_text_editor
alias -s md=default_text_editor
alias -s mp3=default_audio_player
alias -s mkv=default_video_player
alias -s pdf=default_pdf_viewer
alias -s php=default_text_editor
alias -s png=default_image_viewer
alias -s tigrc=default_text_editor
alias -s torrent=default_torrent_app
alias -s txt=default_text_editor
alias -s zshrc=default_text_editor

alias -s webm=default_video_player
alias -s mkv=default_video_player

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# [ -f ~/.nix-profile/etc/profile.d/nix.sh ] && source ~/.nix-profile/etc/profile.d/nix.sh

C() {} # you'll want this so that you don't get a command unrecognized error

preexec() {
  tmp="";
  if [ "${1:0:1}" = "C" ] && [ "${1:1:1}" = " " ] && [ "${1:2:1}" != " " ]; then
    for (( i=2; i<${#1}; i++ )); do
      tmp="${tmp}${1:$i:1}";
    done
    echo "$tmp" | xclip -selection clipboard;
  fi
}

# https://velociraptor.run/ - The script runner for Deno
if [[ -n $(command -v vr) ]]; then
  source <(vr completions zsh) > /dev/null
fi
