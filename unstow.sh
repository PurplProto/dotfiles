#!/usr/bin/env bash

set -e

STOW_DIR=$(dirname "$0")

stow --target "$HOME" --dir "$STOW_DIR" --delete "purplproto"

echo "Now type \". $HOME/.bashrc\""
