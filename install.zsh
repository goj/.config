#!/bin/zsh
mkdir ~/bin 2>/dev/null
foreach file (bin/*) ln -sT `pwd`/$file ~/$file; end
foreach file (_*) ln -sT `pwd`/$file ~/${file:s/_/./}; end
ln -s `pwd`/x-run-here/x-run-here ~/bin
