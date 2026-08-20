#!/usr/bin/env bash

set -euo pipefail

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
source_config="$dotfiles_dir/herdr/config.toml"
target_config="$config_dir/config.toml"

mkdir -p "$config_dir"

if [[ -e "$target_config" && ! -L "$target_config" ]]; then
  backup="$target_config.before-dotfiles-$(date +%Y%m%d-%H%M%S)"
  mv "$target_config" "$backup"
  printf 'Backed up %s to %s\n' "$target_config" "$backup"
fi

ln -sfn "$source_config" "$target_config"
printf 'Linked %s -> %s\n' "$target_config" "$source_config"

if command -v herdr >/dev/null 2>&1; then
  herdr config check
  herdr integration install codex
  herdr integration install cursor
fi
