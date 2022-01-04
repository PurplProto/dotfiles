#!/usr/bin/env bash

# Print what we're doing to the console
set -x

projectLocation="$(dirname "$(readlink -f "$0")")"

homeFiles=(
    .bash_aliases
    .bash_ps # Depends on git-prompt
    .bash_ssh
    .bashrc
    .gitconfig
    .vimrc
)

depFiles=(
    git-prompt/.git-prompt.sh
)

for FILE in "${homeFiles[@]}"; do
    mv "$HOME/$FILE" "$HOME/$FILE.bak"
    ln -s "$projectLocation/configs/home/$FILE" "$HOME/$FILE"
done

for FILE in "${depFiles[@]}"; do
    ln -s "$projectLocation/dependencies/$FILE" "$HOME/$FILE"
done

# Stop printing each line we execute now
set +x

echo "Now type \". $HOME/.bashrc\""
