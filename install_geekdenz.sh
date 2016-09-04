#!/usr/bin/env bash

#source install.sh

curl https://raw.githubusercontent.com/geekdenz/.dotfiles/master/install.sh | bash

ln -sf ~/.dotfiles/git/gitconfig.local ~/.gitconfig.local
