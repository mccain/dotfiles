#!/usr/bin/env bash

checkAndBackup $HOME/.Xmodmap

ln -sf $PWD/xmodmap/Xmodmap $HOME/.Xmodmap
