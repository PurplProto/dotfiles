#!/usr/bin/env bash

if [[ $SHLVL -gt 1 ]] && [[ "$1" != "-F" ]]; then
  echo "This script should be sourced, not executed."
  echo "Try running: . $0"
  echo "If this was intentional, run with -F to force. You'll need to . $HOME/.bashrc manually afterwards."
  exit 1
fi

STOW_DIR=$(dirname "$0")

mkdir -p "$HOME/.dotfile-overrides"

stow --target "$HOME" --dir "$STOW_DIR" "purplproto"

echo "Sourcing .bashrc..."

. $HOME/.bashrc

echo "Done."
