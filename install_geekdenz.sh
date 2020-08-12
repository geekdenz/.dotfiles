#!/usr/bin/env bash

#source install.sh

curl https://raw.githubusercontent.com/geekdenz/.dotfiles/master/install.sh | bash

ln -sf ~/.dotfiles/git/gitconfig.local ~/.gitconfig.local
ln -sf ~/.dotfiles/shells/zshrc ~/.zshrc
ln -sf ~/.dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
ln -sf ~/.dotfiles/shells/ssh-add.sh ~/.config/autostart-scripts/ssh-add.sh
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

