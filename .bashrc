# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# My Functions

# Function to go n directorys back ---------------------------------
cb_internal() {
    local cmd="${1:-cb}"
    local n="${cmd//[!0-9]/}"
    [[ -z "$n" ]] && n=1

    local path=""
    for ((i=0; i<n; i++)); do
        path+="../"
    done
    cd "$path"
}

cb() {
    cb_internal cb
}

for i in {2..9}; do
    eval "
    cb$i() {
        cb_internal cb$i
    }"
done
# end of function ---------------------------------------------------

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
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# Terminalconfig
###### CUSTOMIZE PROMPT HERE ######
INITIALIZED=${INITIALIZED:-0}

if [[ $INITIALIZED == 0 ]]
then
    INITIALIZED=1

    BOLD=$(tput bold)
    WHITE=$(tput setaf 15)
    MAGENTA=$(tput setaf 5)
    WHITE_BLUE=$(tput setaf 189)
    TEAL=$(tput setaf 80)
    YELLOW=$(tput setaf 11)
    GREEN=$(tput setaf 10)
    GREEN_2=$(tput setaf 2)
    RED=$(tput setaf 9)
    ORANGE=$(tput setaf 208)
    PURPLE=$(tput setaf 140)
    RESET=$(tput sgr0)

    # ignore unicodes for now, they are buggy and cause a crash (bad alloc)
    function print_symbol()
    {
        if [[ $1 == 0 ]]
        then
            #echo -e "\001\e[01;32m\002\xe2\x9c\x93"
            echo -e "\001\e[07;32m\002  \001$RESET\002"
        else
            echo -e "\001\e[07;31m\002  \001$RESET\002"
            #echo -e "\001\e[01;31m\002\xe2\x9c\x97"
        fi
    }

    function print_uid()
    {
        if [[ ${EUID} == 0 ]]
        then
            echo -e "\001\e[01;31m\002\h"
        else
            echo -e "\001\e[01;33m\002\u@\h"
        fi
    }

    function set_prompt()
    {
        rc=$?
        PS1=" \[$BOLD\]\$? $(print_symbol $rc)\[$RED\]\[$BOLD\] \[$PURPLE\]\u\[$WHITE_BLUE\]@\[$TEAL\]\h\[$WHITE_BLUE\]:\[$MAGENTA\]\w\[$WHITE\]\$(__git_ps1)>\[$RESET\] "
        #with UID
        #PS1=" \[$BOLD\]\$? $(print_symbol) $(print_uid)\[$WHITE\] \w \[$GREEN\]\\$\[$RESET\] "
    }

PROMPT_COMMAND="set_prompt ${PROMPT_COMMAND:+; $PROMPT_COMMAND}; history -a; history -c; history -r;"
PROMPT_DIRTRIM=3
fi
###### END OF PROMPT CUSTOMIZATION ######
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#Start tmux with config
starttmux() {
  SESSION="default"

  if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach-session -t "$SESSION"
  else
    tmux new-session -d -s "$SESSION"
    tmux split-window -h
    tmux select-pane -t "$SESSION:0.1"
    tmux split-window -v
    tmux select-pane -t "$SESSION:0.0"
    tmux attach-session -t "$SESSION"
  fi
}


