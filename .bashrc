# .bashrc

# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f ~/.bash_colors ]; then
. ~/.bash_colors 
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTIGNORE='&:bg:fg:ll:h'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Displays time in the top right corner
PS_CLOCK="\[\033[s\]\[\033[1;\$((COLUMNS-4))f\]\$(date +%H:%M)\[\033[u\]" # Clock in top right corner

# Variables I'm using:
PS_SPC="    " # Currently 5 basic spaces
PS_USR="$txtgrn\u" #  \u : Username
PS_HOST="$bldgrn\h" #  \h : Hostname
PS_DIR="$txtrst $bldblu\w" #  \w : Working directory
PS_CMD_NUM="$undcyn\!" #  \! : Command Number
PS_CURSOR="$bldgrn$"
PS_CMD_TXT="$txtrst $bldwht"
PS_GIT_BRCH_URL="$txtrst$bldylw\$(~/scripts/GitOriginUrl.sh)"
PS_GIT_BRCH_NAME="$txtrst$bldpur\$(~/scripts/GitBranchName.sh)"

PS_TIME="$txtrst\t"
# \n : NewLine

#Looks like: gmctear@computer ~/Repositories/Personal      Personal->master
PS_MAIN="\n$PS_USR@$PS_HOST $PS_DIR $PS_SPC ${PS_GIT_BRCH_URL}->$PS_GIT_BRCH_NAME $PS_SPC $txtrst \n $PS_CMD_NUM$txtrst $PS_CURSOR$PS_CMD_TXT"

PS1=${PS_MAIN} # ${PS_BRANCH}

# Show a timestamp with every history entry
export HISTTIMEFORMAT="%d/%m/%y %T "

#export CATALINA_BASE=~/.netbeans/7.0/apache-tomcat-7.0.14.0_base/

test -s ~/.alias && . ~/.alias || true

#Use VIM instead of VI
alias vi=vim

#VIM bindings in bash
# set -o vi

#Tomcat commands
# tomcatHome="/home/$USER/apache-tomcat-7.0.14/"
tomcatHome="/home/$USER/.netbeans/8.0.2/apache-tomcat-7.0.59.0_base"
tomcatCmd='/opt/apache-tomcat-7.0.59/bin/'
alias tcStart="sudo ${tomcatCmd}catalina.sh run"
alias tcStop="sudo ${tomcatCmd}catalina.sh stop"

homeDir="/home/$USER/"

#Git alias's
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit '
alias gd='git diff '
alias gdc='git diff --cached '
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gr='git reset '
alias gm='git merge '
alias gl='git log '
alias PUSH='~/scripts/gitPush.sh'
alias gplo='git pull origin '
alias gpsho='git push origin '
alias gitgraph='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s" --simplify-by-decoration'

#cd Variations
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

#Hop to key directories
alias cdsr='cd ~/NetBeansProjects/smilereminder3/'
alias cdsrx='cd ~/NetBeansProjects/smilereminder3/srxproj/srxSubscriber/'
alias cdfw='cd ~/NetBeansProjects/smilereminder3/flyway'
alias cdo='cd ~/OnlineScheduling'

alias cdtom='cd '$tomcatHome
alias cdlogs='cdtom; cd logs' 

alias cdjunk='cd ~/junkDir'

alias lynx='lynx -vikeys'

alias dbsr='psql -U srpostgres smilereminder'

alias lsd='find .'  #ls deep

# Functions
# Generate gitignore files by passing in language(s) of choice
function gi() { curl http://www.gitignore.io/api/$@ ;}

# TODO: fix version/path
# addpath /opt/srpostgres/srpostgres_8.3/bin
                            
addpath $HOME/scripts

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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

alias vimsesh="vim -S ~/vim_sessions/`git rev-parse --abbrev-ref HEAD`.vim"
alias vimcur="vim -S ~/.current.vim"

vim()
{
  # osx users, use stty -g
  local STTYOPTS="$(stty --save)"
  stty stop '' -ixoff
  command vim "$@"
  stty "$STTYOPTS"
}

vimBranch() {
  vim -S ~/sessions/$(GitBranchName.sh).vim
}

declare -a aliases=(\
  'gs="git status "'\
  'ga="git add "')

for i in "${aliases[@]}"
do
  echo $i
done

alias cdr="cd ~/Repositories"
alias ll="ls -al"

# Activate git tab completion
source ~/.git-completion.bash

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export CATALINA_HOME="/opt/apache-tomcat-7.0.59"
export PATH=$CATALINA_HOME/bin:$PATH

export PGSQL_HOME="/usr/pgsql-9.4"
export PATH=$PGSQL_HOME/bin:$PATH
