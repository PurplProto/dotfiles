# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ ! "$-" =~ i ]] && return;

# Set default editor
export EDITOR=vim
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Makes GPG signing work
export GPG_TTY=$(tty)

# Update the $PATH var
PATH="$PATH:$HOME/bin:/opt/android-studio/gradle/gradle-3.3/bin"

# History settings and limitations.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Define the default coloured name
if [[ -f ~/.bash_ps ]]; then
    . ~/.bash_ps
else
    PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]\[\033[00m\]$ "
fi

# enable color support of ls and also add handy aliases
if [ -x "/usr/bin/dircolors" ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Additional useful aliases.
alias ll='ls -alF'
alias la='ls -lah'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

test -f ~/.bash_aliases && . ~/.bash_aliases

SSH_ENV="$HOME/.ssh/environment"

# Start ssh-agent
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add ~/.ssh/id_rsa!(*.pub);
}

function sourceSshEnvBash() {
    . "${SSH_ENV}" > /dev/null
}

function sourceSshEnvWindows() {
    if [[ ! `which setx.exe` ]]; then
        return
    fi

    WIN_SSH_ENV=$(cat ~/.ssh/environment | awk 'NR<=2 {print $1}')
    LOOP_COUNT=0

    echo "Setting SSH environment variables for Windows, this will take a moment... Because Windows."

    for LINE in ${WIN_SSH_ENV[@]}; do
        ((LOOP_COUNT++))
        VAR_VAL=()

        IFS='=' read -ra ENV_VAR <<< "$LINE"
        for i in "${ENV_VAR[@]}"; do
            VAR_VAL+=($i)
        done

        echo "Setting Windows env var ${LOOP_COUNT} of 2"
        setx.exe ${VAR_VAL[0]} $VAR_VAL[1]%?} > /dev/null
    done
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    sourceSshEnvBash;
    sourceSshEnvWindows;
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

function npm-do {
    (PATH=$(npm bin):$PATH; eval $@;)
}

# $1 = user
# $2 = command
# $@ = --all --the -f -l -a -g -s
# example - do-as root ls "-lah /tmp"
function do-as {
    local user=$1
    local whichOut=$(which $2)

    if [[ ! -z $whichOut ]]
    then
        local command=$whichOut
    else
        local command=$(readlink -sf $2)
    fi

    shift 2

    local commandString="$command $@"

    sudo su -l $user -s /bin/bash -c "cd `pwd` && $commandString"
}

