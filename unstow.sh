#!/usr/bin/env bash

STOW_DIR=$(dirname "$0")

stow --target "$HOME" --dir "$STOW_DIR" --delete "purplproto"

echo "You may need to restore your own bashrc or from another source i.e. /etc/skel/.bashrc and then source it \". $HOME/.bashrc\""
