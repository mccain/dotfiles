#!/usr/bin/env bash

checkAndBackup $HOME/.zshrc

ln -s $PWD/zsh/zshrc $HOME/.zshrc

mkdir -p $DOTFILES/extra
git clone https://github.com/robbyrussell/oh-my-zsh $DOTFILES/extra/oh-my-zsh
