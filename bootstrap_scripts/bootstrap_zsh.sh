#!/usr/bin/env bash

checkAndBackup $HOME/.zshrc

ln -sf $PWD/zsh/zshrc $HOME/.zshrc

mkdir -p $DOTFILES/extra
# Create the file if it doesn't exist
ZSH_EXTRA=$DOTFILES/extra/zsh_extra
if [[ ! -e $ZSH_EXTRA ]]; then
    touch $ZSH_EXTRA
fi

OMZ=$DOTFILES/extra/oh-my-zsh
rm -rf $OMZ
git clone https://github.com/robbyrussell/oh-my-zsh $OMZ

Z=$DOTFILES/extra/z
rm -rf $Z
git clone https://github.com/rupa/z $Z
