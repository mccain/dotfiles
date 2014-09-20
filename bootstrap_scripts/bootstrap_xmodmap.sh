#!/usr/bin/env bash

checkAndBackup $HOME/.Xmodmap

ln -s $PWD/xmodmap/Xmodmap $HOME/.Xmodmap
