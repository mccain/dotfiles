#!/usr/bin/env bash

wantedDotfiles=(git vim zsh)

export DOTFILES=`dirname ${BASH_SOURCE}`

function checkAndBackup() {
    if [ -e $1 ]; then
        echo " > Backing up $1"
        mv $1 ${1}.`date "+%Y%m%d%H%M%S"`.bak
    fi
}

pushd $DOTFILES > /dev/null

for df in ${wantedDotfiles[*]}
do
    echo "Preparing $df!"
    source bootstrap_scripts/bootstrap_${df}.sh
done

popd > /dev/null
