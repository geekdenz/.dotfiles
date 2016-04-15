#!/usr/bin/env bash

source install.sh

bash <(https://raw.githubusercontent.com/example-user/.dotfiles/master/install.sh)

ln -sf ~/.dotfiles/git/gitconfig.local ~/.gitconfig.local
