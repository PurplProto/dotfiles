#!/usr/bin/env bash

set -Eeuo pipefail

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] && [[ -z ${1:-} ]]; then
  echo "This script should be sourced, not executed."
  echo "Try running: . $0"
  echo "If this was intentional, run with -F to force. You'll need to . $HOME/.bashrc manually afterwards."
  exit 1
fi

function BACKUP_EXISTING_DOTFILES() {
  local BACKUP_DIR="$HOME/.dotfiles-backup"
  local STOW_PKG="$1"
  local FILES_TO_MOVE="$(ls $STOW_BASE_DIR/$STOW_PKG | sed 's/dot-/./g')"
  echo "Backing up existing files..."
  mkdir -p "$BACKUP_DIR"
  for FILE in $FILES_TO_MOVE; do
    if [[ -e "$HOME/$FILE" ]]; then
      mv -v "$HOME/$FILE" "$BACKUP_DIR"
    fi
  done
}

function ENSURE_LINE_IS_IN_FILE() {
  local LINE="$1"
  local FILE="$2"
  local USE_SUDO=${3:-$false}
  if ! grep -qF "$LINE" "$FILE"; then
    $USE_SUDO && echo "$LINE" | sudo tee -a "$FILE" || echo "$LINE" >>"$FILE"
  fi
}

function MAC_SETUP() {
  echo "Detected Darwin, presuming macOS."

  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || echo "Homebrew installation failed. Exiting..." && exit 1
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"

  if ! command -v brew &>/dev/null; then
    echo "Homebrew appears to have been installed, but still cannot be found. Exiting..."
    exit 1
  fi

  if ! command -v stow &>/dev/null; then
    echo "Stow not found. Installing..."
    brew install stow || echo "Stow installation failed. Exiting..." && exit 1
  fi

  if ! brew list bash &>/dev/null; then
    echo "Installing modern bash..."
    brew install bash || echo "bash installation failed. Exiting..." && exit 1
  fi

  # Set modern bash as the default shell
  local BREW_BASH_PATH="$(brew --prefix)/bin/bash"
  ENSURE_LINE_IS_IN_FILE "$BREW_BASH_PATH" "/etc/shells" true
  chsh -s "$BREW_BASH_PATH"
  SHELL="$BREW_BASH_PATH"

  BACKUP_EXISTING_DOTFILES "mac"

  stow --dotfiles --target "$HOME" --dir "$STOW_BASE_DIR" "mac"

  # Add Homebrew to the shell path
  local BASHRC_PRE_HOOK="$HOME/.dotfile-overrides/bashrc.pre"
  # shellcheck disable=SC2016
  local BREW_SHELL_ENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
  local ONEPASS_SSH_AGENT='export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock'
  touch "$BASHRC_PRE_HOOK"
  ENSURE_LINE_IS_IN_FILE "$BREW_SHELL_ENV" "$BASHRC_PRE_HOOK" false
  ENSURE_LINE_IS_IN_FILE "$ONEPASS_SSH_AGENT" "$BASHRC_PRE_HOOK" false
}

function LINUX_SETUP() {
  echo "Stowing linux directory..."
  BACKUP_EXISTING_DOTFILES "linux"
  stow --dotfiles --target "$HOME" --dir "$STOW_BASE_DIR" "linux"
}

function WSL_SETUP() {
  echo "Detected WSL. Stowing wsl directory..."
  BACKUP_EXISTING_DOTFILES "wsl"
  stow --dotfiles --target "$HOME" --dir "$STOW_BASE_DIR" "wsl"
}

STOW_BASE_DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")

# Create a directory for user-specific overrides
mkdir -p "$HOME/.dotfile-overrides"

if [[ $(uname -s) == "Darwin" ]]; then
  MAC_SETUP
elif [[ $(uname -s) == "Linux" ]]; then
  echo "Detected Linux based OS."

  if ! command -v stow &>/dev/null; then
    echo "Stow not found. Installing..."
    sudo apt-get install stow
  fi

  if uname -r | grep WSL2 >/dev/null; then
    WSL_SETUP
  else
    LINUX_SETUP
  fi
else
  echo "Unsupported OS. Please install stow and manually stow the correct directory for your system."
  exit 1
fi

echo "Restarting shell..."

exec $SHELL -ilc "echo Done!; exec $SHELL -il"

################################
# Test backup command to ensure it works aftertwards (will need to use bash replace "dot-" with "." though)
################################
