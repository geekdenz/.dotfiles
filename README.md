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
```

```bash
git clone https://github.com/geekdenz/.dotfiles.git ~/.dotfiles
#  or
# git clone git@github.com:geekdenz/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
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
