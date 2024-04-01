#!/usr/bin/env bash

# Disable shellcheck error for double quoting as this should be a numeric value that we set and control
# shellcheck disable=SC2086
if [ $IS_WSL -eq 1 ]; then
  # shellcheck source=../../.bash_ssh
  . ~/.bash_ssh
fi

ssh "$@"
