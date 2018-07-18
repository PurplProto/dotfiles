#!/bin/bash

projectLocation=$(pwd)

fileNames=(
	.bashrc
	.bash_ps
	.gitconfig
	.vimrc
)

for FILE in ${fileNames[@]}
do
	mv ~/$FILE ~/$FILE.bak
	ln -s $projectLocation/configs/home/$FILE ~/$FILE
done

echo "Now type \"exec .bashrc\""
