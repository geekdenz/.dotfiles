# My .dotfiles

Installation
------------

## Shell prompt

The repository includes a Powerlevel10k Zsh prompt, plus a clean built-in Zsh
fallback for machines where the optional tools are not installed. Run the setup
script from anywhere:

```bash
~/.dotfiles/shells/setup.sh
exec zsh
```

The script creates these links:

- `~/.zshrc` → `~/.dotfiles/shells/zshrc`
- `~/.p10k.zsh` → `~/.dotfiles/shells/.p10k.zsh`
- `~/.bashrc` → `~/.dotfiles/shells/bashrc`

It is safe to run again. A conflicting file or link is moved to a timestamped
`.backup-YYYYMMDD-HHMMSS` path before the new link is created.

For the full icon-rich prompt, install [Oh My Zsh](https://ohmyz.sh/),
[Powerlevel10k](https://github.com/romkatv/powerlevel10k), and select a Nerd
Font in your terminal. Powerlevel10k can be installed with:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Without Powerlevel10k, the config uses an Oh My Zsh theme when available, or a
dependency-free colored prompt otherwise. Customize the full prompt later with
`p10k configure`.

## Legacy full installation

ZSH:

```bash
sudo apt-get install zsh
```

Oh My Zsh:

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```bash
git clone https://github.com/geekdenz/.dotfiles.git ~/.dotfiles
#  or
# git clone git@github.com:geekdenz/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
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
