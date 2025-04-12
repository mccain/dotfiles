#!/usr/bin/env bash

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
backupAndLink $PWD/nvim $XDG_CONFIG_HOME/nvim
