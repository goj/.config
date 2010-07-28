#!/bin/zsh
foreach file (_*) ln -sT `pwd`/$file ~/${file:s/_/./}; end
