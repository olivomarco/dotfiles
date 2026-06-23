# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

psgrep() {
    ps -aux | grep $1 | grep -v grep
}

pskill() {
    local pid

    pid=`ps -ax | grep $1 | grep -v grep | awk '{ print $1 }'`
    echo -n "killing $1 (process $pid)... "
    kill -9 $pid
    echo "slaughtered"
}

xtitle() {
    [[ "$TERM" == "xterm"* ]] && echo -n -e "\033]0;$*\007"
}

cd() {
    builtin cd "$@" && xtitle $USER@$HOSTNAME: $PWD
}

stats() {
    MACHINE=$(uname -n)
    LOGINS=$(who | wc | awk '{ print $1 }')
    LOAD=$(uptime | awk -F'[a-z]:' '{ print $2}')
    UNIQUE=$(who | sort | awk '{ print $1 }' | uniq | wc | awk '{ print $1 }')
    echo "$MACHINE has $LOGINS sessions and a load of$LOAD ($UNIQUE unique users)"
}

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -laF'
#alias la='ls -A'
#alias l='ls -CF'

# always launch GitHub Copilot CLI with all permissions enabled
alias copilot='copilot --yolo'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
# enable kubectl completion features if kubectl is installed
kubectl=$(which kubectl > /dev/null 2>&1)
if [ ! -z $kubectl ] && [ -x $kubectl ]; then
    source <(kubectl completion bash)
fi

# set some more shell options
shopt -s cdspell
shopt -s hostcomplete
set -o ignoreeof

# --- prompt: single-line, colored, git-aware -------------------------------
# print " (branch)" when inside a git repo, nothing otherwise.
# prefer git's own __git_ps1 (richer) if it has been sourced, else fall back
# to a fast, non-blocking lookup so non-git directories aren't slowed down.
__bash_git_branch() {
    if declare -F __git_ps1 >/dev/null 2>&1; then
        __git_ps1 ' (%s)'
        return
    fi
    local branch
    branch=$(git symbolic-ref --short -q HEAD 2>/dev/null) \
        || branch=$(git rev-parse --short HEAD 2>/dev/null) \
        || return
    printf ' (%s)' "$branch"
}

# rebuild PS1 before each prompt so the prompt char reflects the last exit code:
# green '$' on success, red '$' after a failed command.
__bash_set_prompt() {
    local ec=$?
    if [ "$color_prompt" = yes ]; then
        local c_uh='\[\e[01;32m\]'      # user@host  -> bold green
        local c_dir='\[\e[01;34m\]'     # directory  -> bold blue
        local c_git='\[\e[00;33m\]'     # git branch -> yellow
        local c_reset='\[\e[00m\]'
        local c_char='\[\e[01;32m\]'    # prompt char -> green by default
        [ "$ec" -ne 0 ] && c_char='\[\e[01;31m\]'  # red after failure
        PS1="${c_uh}\u@\h${c_reset} ${c_dir}\w${c_reset}${c_git}$(__bash_git_branch)${c_reset} ${c_char}\$${c_reset} "
    else
        PS1="\u@\h \w$(__bash_git_branch) \$ "
    fi
}
PROMPT_COMMAND=__bash_set_prompt
# ---------------------------------------------------------------------------

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export PATH=/opt/homebrew/bin:$PATH

[ -f  $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br

#if [ -f ".venv/bin/activate" ]; then
#  source .venv/bin/activate
#fi

# machine-specific overrides (untracked; keeps the repo clean). put any local
# or experimental tweaks here instead of editing this file, so `git status`
# stays clean. sourced last so it can override anything above.
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

