# Dotfiles

A bunch of nice to haves I like on most environments.

## Features

- SSH script will attempt to connect to an SSH Agent running on Windows (for example, 1Password's built-in agent) when this script in executed in WSL.
- Hidden files are not sourced in the `.dotfile-overrides` directory.
  - All other files placed in here will be sourced as well, this allows additional configs/dotfiles for specific environments

## Usage

### To install the configs

1. Clone the repo.
2. Run `./install-deps.sh` if `stow` is not already installed.
2. Execute `. ./stow.sh` to create symlinks in the user's home directory to the dotfiles here.

### To remove the configs

1. Execute `./unstow.sh` to remove all symlinked dotfiles.
