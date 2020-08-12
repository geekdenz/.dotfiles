# My .dotfiles

Instalation
-------------

ZSH:

```bash
sudo apt-get install zsh
```

Oh My ZSH:

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zsh* # ONLY IF YOU WANT THE DEFAULT FILE FROM THIS REPOSITORY
```

```bash
git clone https://github.com/geekdenz/.dotfiles.git ~/.dotfiles
#  or
# git clone git@github.com:geekdenz/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Note that you need to logout of your current session for everything to work.

Note that there are custom installers for some things:

```bash
~/.dotfiles/installers/
.
└── ubuntu
    └── 16.4
        ├── config.sh
        ├── ctags-patched.sh
        ├── docker.sh
        ├── java.sh
        ├── nvim-master.sh
        ├── nvim.sh
        ├── nvm.sh
        ├── php7.sh
        └── vagrant.sh
```

I usually run these:
```bash
~/.dotfiles/installers/ubuntu/16.4/nvm.sh
```

## Add to ~/.zshrc.local:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

and this to the end of ~./.zshrc:

```bash
```

The below did not work for me
-----------------------------

If you are not me (skips personal config):

```bash
bash <(https://raw.githubusercontent.com/geekdenz/.dotfiles/master/install.sh)
# Linux:
curl https://raw.githubusercontent.com/geekdenz/.dotfiles/master/install.sh | bash
```

If you are me:

First of all, good for you! We are awesome!

```bash
bash <(https://raw.githubusercontent.com/geekdenz/.dotfiles/master/install_geekdenz.sh)
# Linux:
curl https://raw.githubusercontent.com/geekdenz/.dotfiles/master/install_geekdenz.sh | bash
```

Here you will find (among other configs):

- [VIM](vim/README.md)
- [TMUX](tmux/README.md)

# Ctags

- Use patched ctags. See this [link](https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags)
