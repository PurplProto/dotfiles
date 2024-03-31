# shellcheck shell=bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then

    if [ -r ~/.dircolors ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -lah'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Git aliases

# shellcheck disable=SC2142
alias git-list-local-stale-branches='git for-each-ref --format '"'"'%(refname) %(upstream:track)'"'"' refs/heads | awk '"'"'$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'"'"''
# shellcheck disable=SC2154
alias git-prune-local-branches='git fetch -p && for branch in $(git-list-local-stale-branches); do git branch -d $branch; done'
