#!/usr/bin/env bash

checkAndBackup $HOME/.gitconfig
checkAndBackup $HOME/.gitignore

ln -sf $PWD/git/gitconfig $HOME/.gitconfig
ln -sf $PWD/git/gitignore $HOME/.gitignore
