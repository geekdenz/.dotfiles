#!/bin/sh

# Link the shell configuration in this repository into the current user's home.
# Existing files are preserved with a timestamped .backup-* suffix.

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_suffix="backup-$(date +%Y%m%d-%H%M%S)"

link_config() {
  source_path=$1
  target_path=$2

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'Already linked: %s\n' "$target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path="${target_path}.${backup_suffix}"
    mv -- "$target_path" "$backup_path"
    printf 'Backed up: %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -s -- "$source_path" "$target_path"
  printf 'Linked: %s -> %s\n' "$target_path" "$source_path"
}

link_config "$script_dir/zshrc" "$HOME/.zshrc"
link_config "$script_dir/.p10k.zsh" "$HOME/.p10k.zsh"
link_config "$script_dir/bashrc" "$HOME/.bashrc"

printf '\nShell configuration installed. Start a new shell with: exec zsh\n'
printf 'Run ~/.dotfiles/install.sh to install Zsh, Powerlevel10k, and the Nerd Font.\n'
