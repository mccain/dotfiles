#!/usr/bin/env bash

checkAndBackup $HOME/.tmux.conf

ln -sf $PWD/tmux/tmux.conf $HOME/.tmux.conf
