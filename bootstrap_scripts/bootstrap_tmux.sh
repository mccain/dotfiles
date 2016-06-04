#!/usr/bin/env bash

TMUX_EXTRA_FOLDER="$PWD/extra/tmux"

backupAndLink $PWD/tmux/tmux.conf $HOME/.tmux.conf
backupAndLink "$TMUX_EXTRA_FOLDER" "$HOME/.tmux"

mkdir -p "$TMUX_EXTRA_FOLDER"
mkdir -p "$TMUX_EXTRA_FOLDER/plugins"

TMUX_PLUGINS="$TMUX_EXTRA_FOLDER/plugins/tpm"
rm -rf "$TMUX_PLUGINS"
git clone --depth 1 https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS"
