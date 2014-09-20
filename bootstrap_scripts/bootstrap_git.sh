#!/usr/bin/env bash

checkAndBackup $HOME/.gitconfig
checkAndBackup $HOME/.gitignore

ln -s $PWD/git/gitconfig $HOME/.gitconfig
ln -s $PWD/git/gitignore $HOME/.gitignore
