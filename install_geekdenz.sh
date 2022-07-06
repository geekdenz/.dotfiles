#!/bin/bash

./installers/ubuntu/16.4/nvm.sh
nvm install --lts
mkdir -p $HOME/.config/autostart-scripts
ln -sf ~/.dotfiles/shells/ssh-unlock.sh $HOME/.config/autostart-scripts/ssh-unlock.sh
#cp ~/.dotfiles/shells/ssh-unlock.sh $HOME/.config/autostart-scripts/ssh-unlock.sh
mkdir -p ~/.config/plasma-workspace/env && ln -sf ~/.dotfiles/shells/ask-pass.sh ~/.config/plasma-workspace/env/askpass.sh
# ensure powerline is installed
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# install Hack font
curl https://www.fontsquirrel.com/fonts/download/hack > /tmp/hack.zip && \
	pushd /tmp && \
	unzip hack.zip && \
	mkdir ~/.local/share/fonts -p && mv Hack*.ttf ~/.local/share/fonts && \
	rm -f hack.zip && \
	popd

curl -s "https://get.sdkman.io" | bash
