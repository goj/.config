#!/bin/zsh
foreach file (`pwd`/../LEGACY/*) ln -sT $(readlink -f $file) $HOME/.$(basename $file); end
