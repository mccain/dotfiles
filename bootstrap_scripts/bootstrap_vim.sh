#!/usr/bin/env bash

checkAndBackup $HOME/.vimrc
checkAndBackup $HOME/.vim

ln -sf $PWD/vim/vimrc $HOME/.vimrc
ln -sf $PWD/vim $HOME/.vim

# Vim will not create the undos folder automatically
mkdir -p $DOTFILES/vim/undos

# Use vim-plug to manage Vim plugins
curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install the plugins found in vimrc
vim +PlugInstall +qall
