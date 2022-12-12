# My configs

A bunch of configs I like to use on nearly every terminal. This repo makes it easy for me to setup new environments to my preferred configuration.

## Features

- SSH script will attempt to connect to an SSH Agent running on Windows (for example, 1Password's built-in agent) when this script in executed in WSL.
- Hidden files are not sourced in the `.dotfiles-override` directory.
- When using the `manage-links.sh` script to create symlinks, it will attempt to backup existing configs it will replace.
- When using the `manage-links.sh` script to remove symlinks, it will attempt to restore backed up configs so the terminal will remain in a usaable state.

## Usage

### To install the configs

1. Clone the repo.
2. Execute `./manage-links.sh -c` to create symlinks in the user's home directory to the configs here.

### To remove the configs
1. Execute `./manage-links.sh -r` to restore backed up configs, if they were created or still exist.

## TODO
- Check restore process is sound
