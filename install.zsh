#!/bin/zsh
foreach file (bin/*) ln -sT `pwd`/$file ~/$file; end
foreach file (_*) ln -sT `pwd`/$file ~/${file:s/_/./}; end
