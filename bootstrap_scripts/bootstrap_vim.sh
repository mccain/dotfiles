#!/usr/bin/env bash

checkAndBackup $HOME/.vimrc
checkAndBackup $HOME/.vim

ln -s $PWD/vim/vimrc $HOME/.vimrc
ln -s $PWD/vim $HOME/.vim

# Vim will not create the undos folder automatically
mkdir ~/.vim/undos

mkdir ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/jnurmine/Zenburn ~/.vim/bundle/Zenburn
