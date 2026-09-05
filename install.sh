#!/bin/sh

# One-shot dotfiles bootstrap for Debian- and Arch-based Linux systems.
# Safe to rerun: managed links are left alone and conflicting files are backed up.

set -eu

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_suffix="before-dotfiles-$(date +%Y%m%d-%H%M%S)"

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'dotfiles install: %s\n' "$*" >&2
  exit 1
}

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "root privileges are required; install sudo or run as root"
  fi
}

install_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    log "Installing Debian packages"
    as_root env DEBIAN_FRONTEND=noninteractive apt-get update
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl gettext fontconfig fzf git openssh-client pinentry-curses unzip wl-clipboard zsh
    platform=debian
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing Arch packages"
    as_root pacman -Syu --needed --noconfirm \
      ca-certificates curl gettext fontconfig fzf git openssh pinentry ttf-jetbrains-mono-nerd unzip wl-clipboard zsh
    platform=arch
  else
    die "unsupported distribution: expected apt-get or pacman"
  fi
}

backup_target() {
  target=$1
  backup="${target}.${backup_suffix}"
  counter=0
  while [ -e "$backup" ] || [ -L "$backup" ]; do
    counter=$((counter + 1))
    backup="${target}.${backup_suffix}.${counter}"
  done
  mv -- "$target" "$backup"
  printf 'Backed up: %s -> %s\n' "$target" "$backup"
}

link_config() {
  source_path=$1
  target_path=$2

  [ -e "$source_path" ] || die "managed source does not exist: $source_path"
  mkdir -p "$(dirname -- "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink -f -- "$target_path")" = "$(readlink -f -- "$source_path")" ]; then
    printf 'Already linked: %s\n' "$target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_target "$target_path"
  fi

  ln -s -- "$source_path" "$target_path"
  printf 'Linked: %s -> %s\n' "$target_path" "$source_path"
}

clone_or_update() {
  repository=$1
  destination=$2

  if [ -d "$destination/.git" ]; then
    printf 'Already installed: %s\n' "$destination"
  elif [ -e "$destination" ]; then
    die "$destination exists but is not a Git checkout"
  else
    git clone --depth=1 "$repository" "$destination"
  fi
}

install_jetbrains_font() {
  [ "$platform" = debian ] || return 0

  font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerd"
  if find "$font_dir" -maxdepth 1 -type f -name '*.ttf' -print -quit 2>/dev/null | grep -q .; then
    printf 'Already installed: JetBrainsMono Nerd Font\n'
    return
  fi

  log "Installing JetBrainsMono Nerd Font"
  archive=$(mktemp)
  trap 'rm -f "$archive"' EXIT HUP INT TERM
  curl -fL --retry 3 \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
    -o "$archive"
  mkdir -p "$font_dir"
  unzip -q -o "$archive" '*.ttf' -d "$font_dir"
  rm -f "$archive"
  trap - EXIT HUP INT TERM
  fc-cache -f "$font_dir" >/dev/null
}

install_fzf() {
  if command -v fzf >/dev/null 2>&1; then
    printf 'Already installed: fzf (%s)\n' "$(fzf --version 2>/dev/null | head -n1 || echo 'present')"
    return 0
  fi

  log "Installing fzf via git fallback"
  clone_or_update https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --bin --no-key-bindings --no-completion --no-update-rc
  mkdir -p "${XDG_BIN_HOME:-$HOME/.local/bin}"
  ln -sf "$HOME/.fzf/bin/fzf" "${XDG_BIN_HOME:-$HOME/.local/bin}/fzf"
}

install_packages

log "Installing shell framework and prompt"
clone_or_update https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_or_update https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
install_fzf
install_jetbrains_font

log "Linking dotfiles"
link_config "$dotfiles_dir/shells/bashrc" "$HOME/.bashrc"
link_config "$dotfiles_dir/shells/zshrc" "$HOME/.zshrc"
link_config "$dotfiles_dir/shells/.p10k.zsh" "$HOME/.p10k.zsh"
link_config "$dotfiles_dir/git/gitconfig" "$HOME/.gitconfig"
link_config "$dotfiles_dir/git/gitignore_global" "$HOME/.gitignore_global"
link_config "$dotfiles_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
link_config "$dotfiles_dir/ruby/irbrc" "$HOME/.irbrc"
link_config "$dotfiles_dir/vim/ideavimrc" "$HOME/.ideavimrc"
link_config "$dotfiles_dir/ctags" "$HOME/.ctags"
link_config "$dotfiles_dir/agignore" "$HOME/.agignore"
link_config "$dotfiles_dir/nvim" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
link_config "$dotfiles_dir/herdr/config.toml" "${XDG_CONFIG_HOME:-$HOME/.config}/herdr/config.toml"
link_config "$dotfiles_dir/.wezterm.lua" "$HOME/.wezterm.lua"
link_config "$dotfiles_dir/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
link_config "$dotfiles_dir/bin/wl-copy" "$HOME/.local/bin/wl-copy"
link_config "$dotfiles_dir/systemd/user/ssh-agent.service" "$HOME/.config/systemd/user/ssh-agent.service"

if [ -r "$dotfiles_dir/.env" ]; then
  "$dotfiles_dir/scripts/render-local-configs"
else
  printf 'Copy .env.example to .env to render machine-specific Git and Remmina settings.\n'
fi

if command -v systemctl >/dev/null 2>&1; then
  systemctl --user daemon-reload || printf 'Warning: could not reload the user systemd manager.\n' >&2
  systemctl --user enable --now ssh-agent.service || \
    printf 'Warning: could not enable the user SSH agent; start it after logging into your desktop.\n' >&2
fi

if [ -d /usr/share/omarchy ]; then
  link_config "$dotfiles_dir/hypr" "${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
  link_config "$dotfiles_dir/omarchy/xdg-terminals.list" "${XDG_CONFIG_HOME:-$HOME/.config}/xdg-terminals.list"
fi

chmod 700 "$HOME/.gnupg"

if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --kill gpg-agent >/dev/null 2>&1 || true
fi

current_shell=$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7 || true)
zsh_path=$(readlink -f "$(command -v zsh)")
if [ "$current_shell" != "$zsh_path" ] && command -v chsh >/dev/null 2>&1; then
  log "Setting the default shell to Zsh"
  if [ "$(id -u)" -eq 0 ]; then
    chsh -s "$zsh_path" "$(id -un)" || printf 'Warning: could not change the default shell.\n' >&2
  else
    as_root chsh -s "$zsh_path" "$(id -un)" || printf 'Warning: could not change the default shell.\n' >&2
  fi
fi

if command -v herdr >/dev/null 2>&1; then
  herdr config check
fi

log "Installation complete"
printf 'Start Zsh now with: exec zsh\n'
