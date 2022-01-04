# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ ! "$-" =~ i ]] && return;

export EDITOR=vim
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export GPG_TTY=$(tty) # Makes GPG signing work

# History settings and limitations.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Set shell options
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

test -f ~/.bash_aliases && . ~/.bash_aliases

SYS_TYPE=$(uname -s | cut -d\- -f1) # To handle WSL, GitBash on the same machine
SSH_ENV="${HOME}/.ssh/.environment-${SYS_TYPE}"
SSH_SOCK_PATH="${HOME}/.ssh-agent-${SYS_TYPE}.sock"

function sourceSshEnvBash() {
    . $SSH_ENV > /dev/null
}

function setWinVarsWhenGitBash() {
    if [[ $SYS_TYPE == "MINGW64_NT" ]]; then
        setx.exe SSH_AUTH_SOCK $SSH_AUTH_SOCK > /dev/null
        setx.exe SSH_AGENT_PID $SSH_AGENT_PID > /dev/null
    fi
}

function recoverAgentPid() {
    local -
    set -e
    set -o pipefail
    ps -ef | grep /usr/bin/ssh-agent | grep -v grep | awk 'FNR == 1 {print $2}' 2> /dev/null
}

function agentIsInRunnableState() {
    recoverAgentPid > /dev/null  && test -e $SSH_AUTH_SOCK
}

function recoverAgent() {
    agentPid=$(recoverAgentPid)

    if agentIsInRunnableState; then
        export SSH_AUTH_SOCK=$SSH_SOCK_PATH
        export SSH_AGENT_PID=$agentPid

        echo "SSH_AUTH_SOCK=${SSH_AUTH_SOCK}; export SSH_AUTH_SOCK;" > $SSH_ENV
        echo "SSH_AGENT_PID=${SSH_AGENT_PID}; export SSH_AGENT_PID;" >> $SSH_ENV
        echo "#echo Agent pid ${SSH_AGENT_PID};" >> $SSH_ENV

        /bin/chmod 600 $SSH_ENV
        return 0
    fi

    rm -f $SSH_SOCK_PATH
    rm -f $SSH_ENV
    return 1
}

function initNewAgent() {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent -a "${SSH_SOCK_PATH}" | sed 's/^echo/#echo/' > "${SSH_ENV}" && echo "Succeeded"
    /bin/chmod 600 "${SSH_ENV}"
    sourceSshEnvBash
    /usr/bin/ssh-add "${HOME}/.ssh/id_"!(*.pub)
}

test -f $SSH_ENV && sourceSshEnvBash && agentIsInRunnableState || recoverAgent || initNewAgent
setWinVarsWhenGitBash
