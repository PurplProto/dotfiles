#!/usr/bin/env bash

ISWSL=$(uname -r | grep WSL2 > /dev/null && echo 1 || echo 0)

if [ $ISWSL -eq 1 ]; then
  . ~/.bash_ssh
fi

ssh "$@"
