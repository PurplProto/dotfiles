#!/usr/bin/env bash

STOW_DIR=$(dirname "$0")
STOW_PKG=""

if [[ $(uname -s) == "Darwin" ]]; then
  STOW_PKG="mac"
elif [[ $(uname -s) == "Linux" ]]; then
  STOW_PKG="linux"
  if uname -r | grep WSL2 >/dev/null; then
    STOW_PKG="wsl"
  fi
else
  echo "Unsupported OS. Exiting..."
  exit 1
fi

stow --target "$HOME" --dir "$STOW_DIR" --delete "$STOW_PKG"

# Remove symlinks in $HOME pointing to this dotfiles repo
if [[ "$1" == "--cleanup" || "$1" == "--cleanup-dry-run" ]]; then
  echo "Scanning $HOME for symlinks pointing to $STOW_DIR..."

  find "$HOME" -maxdepth 1 -type l | while read -r link; do
    target=$(readlink -f "$link")
    stow_source=$(readlink -f "$STOW_DIR")
    if [[ "$target" == $stow_source* ]]; then
      if [[ "$1" == "--cleanup-dry-run" ]]; then
        echo "Would remove symlink: $link -> $target"
      else
        echo "Removing symlink: $link -> $target"
        rm "$link"
      fi
    fi
  done
fi

echo "You may need to restore your own bashrc or from another source i.e. /etc/skel/.bashrc and then source it \". $HOME/.bashrc\""
