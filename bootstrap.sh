#!/usr/bin/env bash

wantedDotfiles=(git vim zsh tmux)

export DOTFILES=`dirname ${BASH_SOURCE}`

function backupAndLink() {
    local source_file=$1
    local target_file=$2
    if [[ -e $target_file && ! -L $target_file ]]; then
        echo " > Backing up $target_file"
        mv $target_file ${target_file}.`date "+%Y%m%d%H%M%S"`.bak
    fi
    # Delete symbolic link to avoid potentially unwanted links
    if [[ -L $target_file ]]; then
        rm $target_file
    fi
    ln -s $source_file $target_file
}

pushd $DOTFILES > /dev/null

for df in ${wantedDotfiles[*]}
do
    echo "Preparing $df!"
    source bootstrap_scripts/bootstrap_${df}.sh
done

popd > /dev/null
