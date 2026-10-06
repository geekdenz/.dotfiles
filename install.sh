#!/bin/sh

# One-shot dotfiles bootstrap for Debian-, Arch- and Alpine-based Linux systems
# and MSYS2 on Windows.
# Safe to rerun: managed links are left alone and conflicting files are backed up.

set -eu

dotfiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_suffix="before-dotfiles-$(date +%Y%m%d-%H%M%S)"

case "$(uname -s)" in
  MSYS_NT* | MINGW*_NT* | UCRT64_NT* | CLANG*_NT*) is_msys2=true ;;
  *) is_msys2=false ;;
esac

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'dotfiles install: %s\n' "$*" >&2
  exit 1
}

as_root() {
  # Windows has no sudo; MSYS2 already owns its own package tree.
  if [ "$is_msys2" = true ] || [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  elif command -v doas >/dev/null 2>&1; then
    doas "$@"
  else
    die "root privileges are required; install sudo or doas, or run as root"
  fi
}

install_packages() {
  if [ "$is_msys2" = true ]; then
    # MSYS2 also ships pacman, so it must be matched before Arch. A full -Syu
    # can update the MSYS2 runtime and kill this shell midway, so only refresh
    # the databases here; run pacman -Syu yourself beforehand.
    log "Installing MSYS2 packages"
    pacman -Sy --needed --noconfirm \
      ca-certificates curl gettext git gnupg openssh pinentry unzip zsh \
      "${MINGW_PACKAGE_PREFIX:-mingw-w64-ucrt-x86_64}-fzf" \
      "${MINGW_PACKAGE_PREFIX:-mingw-w64-ucrt-x86_64}-ripgrep" \
      "${MINGW_PACKAGE_PREFIX:-mingw-w64-ucrt-x86_64}-fd" \
      "${MINGW_PACKAGE_PREFIX:-mingw-w64-ucrt-x86_64}-nodejs"
    platform=msys2
  elif command -v apk >/dev/null 2>&1; then
    # bash runs the helper scripts and the .NET installer; icu-libs,
    # libgcc and libstdc++ are the .NET SDK's runtime dependencies on musl.
    log "Installing Alpine packages"
    as_root apk add --no-cache \
      bash ca-certificates curl fd fontconfig fzf gettext-envsubst git icu-libs libgcc libstdc++ \
      nodejs npm openssh-client pinentry ripgrep unzip wl-clipboard zsh
    platform=alpine
  elif command -v apt-get >/dev/null 2>&1; then
    log "Installing Debian packages"
    as_root env DEBIAN_FRONTEND=noninteractive apt-get update
    # The .NET SDK needs ICU, whose package name carries its version number.
    libicu=$(apt-cache search --names-only '^libicu[0-9]+$' | awk '{ print $1 }' | sort -V | tail -n 1)
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl gettext fd-find fontconfig fzf git $libicu openssh-client pinentry-curses ripgrep unzip wl-clipboard zsh
    platform=debian
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing Arch packages"
    as_root pacman -Syu --needed --noconfirm \
      ca-certificates curl fd gettext fontconfig fzf git icu openssh pinentry ripgrep ttf-jetbrains-mono-nerd unzip wl-clipboard zsh
    platform=arch
  else
    die "unsupported distribution: expected apk, apt-get or pacman"
  fi
}

windows_path() {
  cygpath -u "$1"
}

require_native_symlinks() {
  # Without this MSYS2's ln -s silently copies files instead of linking them.
  MSYS="${MSYS:+$MSYS }winsymlinks:nativestrict"
  export MSYS

  probe=$(mktemp -d)
  if ! ln -s -- "$dotfiles_dir/install.sh" "$probe/link" 2>/dev/null; then
    rm -rf -- "$probe"
    die "cannot create Windows symlinks; enable Developer Mode (Settings > System > For developers) or run MSYS2 as Administrator"
  fi
  rm -rf -- "$probe"
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

install_node() {
  # MSYS2 and Alpine get Node.js from their package managers: nvm does not
  # support Windows, and has no prebuilt Node.js binaries for musl.
  case "$platform" in msys2 | alpine) return 0 ;; esac

  nvm_dir="$HOME/.nvm"
  if [ ! -s "$nvm_dir/nvm.sh" ]; then
    [ -e "$nvm_dir" ] && die "$nvm_dir exists but does not contain nvm"
    nvm_tag=$(git ls-remote --tags --sort=-v:refname https://github.com/nvm-sh/nvm.git 'v*' |
      awk '$2 !~ /\^\{\}$/ { sub("refs/tags/", "", $2); print $2; exit }')
    [ -n "$nvm_tag" ] || die "could not look up the latest nvm release"
    git -c advice.detachedHead=false clone --depth=1 --branch "$nvm_tag" \
      https://github.com/nvm-sh/nvm.git "$nvm_dir"
  fi

  # nvm.sh is not safe under set -eu, so it runs in its own shell. Mason uses
  # npm to install the TypeScript, JSON, Svelte and Elm language servers.
  NVM_DIR="$nvm_dir" bash -c '. "$NVM_DIR/nvm.sh" && nvm install --lts && nvm alias default "lts/*"'
}

install_dotnet() {
  if [ "$platform" = msys2 ]; then
    command -v dotnet >/dev/null 2>&1 ||
      printf 'Install the .NET SDK for F#/C# in Neovim with: winget install Microsoft.DotNet.SDK.10\n'
    return
  fi

  if [ -x "$HOME/.dotnet/dotnet" ]; then
    printf 'Already installed: .NET SDK\n'
    return
  fi

  # A per-user SDK works the same on every distribution and needs no root.
  # Mason uses it to install fsautocomplete, fantomas and csharpier.
  script=$(mktemp)
  trap 'rm -f "$script"' EXIT HUP INT TERM
  curl -fsSL --retry 3 https://dot.net/v1/dotnet-install.sh -o "$script"
  bash "$script" --channel LTS --install-dir "$HOME/.dotnet"
  rm -f "$script"
  trap - EXIT HUP INT TERM
}

install_windows_jetbrains_font() {
  # Per-user font install: no administrator rights needed, but Windows only
  # sees the files once they are registered under HKCU.
  font_dir="$(windows_path "$LOCALAPPDATA")/Microsoft/Windows/Fonts"
  if find "$font_dir" -maxdepth 1 -type f -name 'JetBrainsMonoNerd*.ttf' -print -quit 2>/dev/null | grep -q .; then
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

  for font in "$font_dir"/JetBrainsMonoNerd*.ttf; do
    name=$(basename -- "$font" .ttf)
    # Stop MSYS2 from rewriting reg.exe's /v, /t, /d and /f switches as paths.
    MSYS2_ARG_CONV_EXCL='*' reg.exe add \
      'HKCU\Software\Microsoft\Windows NT\CurrentVersion\Fonts' \
      /v "$name (TrueType)" /t REG_SZ /d "$(cygpath -w "$font")" /f >/dev/null
  done
}

install_jetbrains_font() {
  if [ "$platform" = msys2 ]; then
    install_windows_jetbrains_font
    return
  fi
  case "$platform" in debian | alpine) ;; *) return 0 ;; esac

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

install_packages
[ "$platform" = msys2 ] && require_native_symlinks

log "Installing shell framework and prompt"
clone_or_update https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_or_update https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
install_jetbrains_font

log "Installing Neovim language server runtimes"
install_node
install_dotnet

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
link_config "$dotfiles_dir/bin/ssh-askpass-tty" "$HOME/.local/bin/ssh-askpass-tty"

# Debian renames fd to fdfind to avoid a clash with an unrelated package.
if [ "$platform" = debian ]; then
  link_config /usr/bin/fdfind "$HOME/.local/bin/fd"
fi

if [ "$platform" = msys2 ]; then
  # Native Windows builds of WezTerm and Neovim look in the Windows profile,
  # not in the MSYS2 home directory.
  link_config "$dotfiles_dir/.wezterm.lua" "$(windows_path "$USERPROFILE")/.wezterm.lua"
  link_config "$dotfiles_dir/nvim" "$(windows_path "$LOCALAPPDATA")/nvim"
  # gpg-agent.conf hard-codes /usr/bin/pinentry-curses; only use it if present.
  if [ -x /usr/bin/pinentry-curses ]; then
    link_config "$dotfiles_dir/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
  fi
else
  link_config "$dotfiles_dir/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
  link_config "$dotfiles_dir/bin/browser-tab" "$HOME/.local/bin/browser-tab"
  link_config "$dotfiles_dir/shells/ssh_askpass.conf" "${XDG_CONFIG_HOME:-$HOME/.config}/environment.d/ssh_askpass.conf"
  link_config "$dotfiles_dir/systemd/user/ssh-agent.service" "$HOME/.config/systemd/user/ssh-agent.service"
fi

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
  omarchy_config="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy"
  link_config "$dotfiles_dir/hypr" "${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
  link_config "$dotfiles_dir/omarchy/xdg-terminals.list" "${XDG_CONFIG_HOME:-$HOME/.config}/xdg-terminals.list"
  link_config "$dotfiles_dir/omarchy/shell.json" "$omarchy_config/shell.json"
  # Each plugin must be linked under the id its manifest declares, which is
  # also the id shell.json enables; the shared config drops the username.
  link_config "$dotfiles_dir/omarchy/plugins/local.lock" "$omarchy_config/plugins/example-user.lock"
  link_config "$dotfiles_dir/omarchy/plugins/local.notifications" \
    "$omarchy_config/plugins/example-user.notifications"
fi

mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --kill gpg-agent >/dev/null 2>&1 || true
fi

if [ "$platform" = msys2 ]; then
  # MSYS2 has no chsh; the launcher chooses the shell.
  printf 'Start MSYS2 with Zsh via: msys2_shell.cmd -ucrt64 -shell zsh\n'
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
