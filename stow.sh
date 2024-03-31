#!/usr/bin/env bash

set -e

STOW_DIR=$(dirname "$0")

mkdir -p "$HOME/.dotfile-overrides"

stow --target "$HOME" --dir "$STOW_DIR" "purplproto"

echo "Now type \". $HOME/.bashrc\""
