#!/bin/bash

set -x

projectLocation=$(pwd)

homeFiles=(
	.bashrc
	.bash_ps
	.gitconfig
	.vimrc
)

depFiles=(
    .git-prompt.sh
)

for FILE in "${homeFiles[@]}"
do
	mv "~/$FILE" ~/$FILE.bak
	ln -s "$projectLocation/configs/home/$FILE" ~/$FILE
done

for FILE in "${depFiles[@]}"
do
	ln -s "$projectLocation/dependencies/$FILE" ~/$FILE
done

echo "Now type \"exec .bashrc\""

