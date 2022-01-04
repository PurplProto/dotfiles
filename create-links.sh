#!/bin/bash

set -x

projectLocation="$(dirname "$(readlink -f "$0")")"

homeFiles=(
    .bashrc
    .bash_ps
    .gitconfig
    .vimrc
)

depFiles=(
    git-prompt/.git-prompt.sh
)

for FILE in "${homeFiles[@]}"
do
    mv "$HOME/$FILE" $HOME/$FILE.bak
    ln -s "$projectLocation/configs/home/$FILE" $HOME/$FILE
done

for FILE in "${depFiles[@]}"
do
    ln -s "$projectLocation/dependencies/$FILE" $HOME/$FILE
done

echo "Now type \". $HOME/.bashrc\""
