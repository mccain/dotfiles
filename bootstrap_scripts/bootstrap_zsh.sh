#!/usr/bin/env bash

checkAndBackup $HOME/.zshrc

ln -sf $PWD/zsh/zshrc $HOME/.zshrc

mkdir -p $DOTFILES/extra

OMZ=$DOTFILES/extra/oh-my-zsh
rm -rf $OMZ
git clone https://github.com/robbyrussell/oh-my-zsh $OMZ
