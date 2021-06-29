#!/bin/bash

sudo apt update && sudo apt install -y zsh vim-gtk git-all && \
./install.sh
./installers/ubuntu/16.4/nvm.sh
nvm install --lts
mkdir -p $HOME/.config/autostart-scripts
ln -sf ~/.dotfiles/shells/ssh-unlock.sh $HOME/.config/autostart-scripts/ssh-unlock.sh
#cp ~/.dotfiles/shells/ssh-unlock.sh $HOME/.config/autostart-scripts/ssh-unlock.sh
mkdir -p ~/.config/plasma-workspace/env && ln -sf ~/.dotfiles/shells/ask-pass.sh ~/.config/plasma-workspace/env/askpass.sh
# ensure powerline is installed
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# install Hack font
curl https://www.fontsquirrel.com/fonts/download/hack > /tmp/hack.zip && \
	pushd /tmp && \
	unzip hack.zip && \
	mkdir ~/.local/share/fonts -p && mv Hack*.ttf ~/.local/share/fonts && \
	rm -f hack.zip && \
	popd

curl -s "https://get.sdkman.io" | bash
