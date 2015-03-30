#!/usr/bin/env bash

checkAndBackup $HOME/.vimrc
checkAndBackup $HOME/.vim

ln -sf $PWD/vim/vimrc $HOME/.vimrc
ln -sf $PWD/vim $HOME/.vim

# Vim will not create the undos folder automatically
mkdir -p $DOTFILES/vim/undos
mkdir -p $DOTFILES/vim/bundle

Vundle=$DOTFILES/vim/bundle/Vundle.vim
rm -rf $Vundle
git clone https://github.com/gmarik/Vundle.vim.git $Vundle

# Install the plugins found in vimrc
vim +PluginInstall +qall
