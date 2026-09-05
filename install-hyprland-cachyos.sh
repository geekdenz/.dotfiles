#!/usr/bin/env bash

# Install a usable Hyprland desktop on CachyOS without replacing the existing
# desktop environment. Safe to rerun: pacman uses --needed, the managed config
# link is stable, and the original login-manager config is backed up once.

set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
session_file="hyprland-uwsm.desktop"

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'Hyprland install: %s\n' "$*" >&2
  exit 1
}

as_root() {
  if [[ $(id -u) -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "root privileges are required; install sudo or run this script with sudo"
  fi
}

if [[ ! -r /etc/os-release ]]; then
  die "cannot identify this Linux distribution"
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ ${ID:-} != "cachyos" ]]; then
  die "this script supports CachyOS only (detected ${PRETTY_NAME:-unknown})"
fi

if [[ $(id -u) -eq 0 ]]; then
  target_user=${SUDO_USER:-}
  if [[ -z $target_user && -n ${PKEXEC_UID:-} ]]; then
    target_user=$(id -nu "$PKEXEC_UID")
  fi
  [[ -n $target_user && $target_user != "root" ]] || \
    die "run as your normal desktop user; the script will use sudo or Polkit when needed"
else
  target_user=$(id -un)
fi

target_home=$(getent passwd "$target_user" | cut -d: -f6)
[[ -n $target_home && -d $target_home ]] || die "cannot find a home directory for $target_user"
target_group=$(id -gn "$target_user")

packages=(
  brightnessctl
  cachyos-wallpapers
  dolphin
  fzf
  grim
  gettext
  hypridle
  hyprland
  hyprlock
  hyprpicker
  hyprpolkitagent
  libnotify
  mako
  network-manager-applet
  noto-fonts-emoji
  openssh
  pavucontrol
  playerctl
  qt5-wayland
  qt6-wayland
  slurp
  swaybg
  tesseract
  tesseract-data-eng
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  uwsm
  waybar
  wezterm
  wl-clipboard
  wofi
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xorg-xwayland
)

log "Installing Hyprland and CachyOS packages"
# Arch-based systems do not support partial upgrades, so synchronize and
# upgrade before installing the requested packages.
as_root pacman -Syu --needed --noconfirm "${packages[@]}"

[[ -f /usr/share/wayland-sessions/$session_file ]] || \
  die "Hyprland's UWSM session was not installed"

log "Linking the tracked CachyOS Hyprland configuration"
source_config="$script_dir/hypr-cachyos"
target_config="$target_home/.config/hypr"
[[ -f $source_config/hyprland.lua ]] || die "missing $source_config/hyprland.lua"
[[ -x $source_config/scripts/capture-text ]] || \
  die "missing executable $source_config/scripts/capture-text"
[[ -x $source_config/scripts/daily-wallpaper ]] || \
  die "missing executable $source_config/scripts/daily-wallpaper"
[[ -x $source_config/scripts/launch-waybar ]] || \
  die "missing executable $source_config/scripts/launch-waybar"

target_systemd_user="$target_home/.config/systemd/user/ssh-agent.service"
install -d -m 0755 "$(dirname -- "$target_systemd_user")"
if [[ -e $target_systemd_user || -L $target_systemd_user ]]; then
  if [[ ! -L $target_systemd_user || $(readlink -f -- "$target_systemd_user") != $(readlink -f -- "$script_dir/systemd/user/ssh-agent.service") ]]; then
    backup="$target_systemd_user.before-dotfiles-$(date +%Y%m%d-%H%M%S)"
    mv -- "$target_systemd_user" "$backup"
    printf 'Backed up: %s -> %s\n' "$target_systemd_user" "$backup"
  fi
fi
if [[ ! -e $target_systemd_user && ! -L $target_systemd_user ]]; then
  ln -s -- "$script_dir/systemd/user/ssh-agent.service" "$target_systemd_user"
  printf 'Linked: %s -> %s\n' "$target_systemd_user" "$script_dir/systemd/user/ssh-agent.service"
fi

if [[ -L $target_config ]] && \
   [[ $(readlink -f -- "$target_config") == $(readlink -f -- "$source_config") ]]; then
  printf 'Already linked: %s\n' "$target_config"
else
  if [[ -e $target_config || -L $target_config ]]; then
    backup="$target_config.before-cachyos-hyprland-$(date +%Y%m%d-%H%M%S)"
    mv -- "$target_config" "$backup"
    printf 'Backed up: %s -> %s\n' "$target_config" "$backup"
  fi

  install -d -m 0755 "$target_home/.config"
  ln -s -- "$source_config" "$target_config"
  if [[ $(id -u) -eq 0 ]]; then
    chown "$target_user:$target_group" "$target_home/.config"
    chown -h "$target_user:$target_group" "$target_config"
  fi
  printf 'Linked: %s -> %s\n' "$target_config" "$source_config"
fi

log "Setting Hyprland as the default login session"
display_manager=$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || true)

case $display_manager in
  */plasmalogin.service)
    command -v kwriteconfig6 >/dev/null 2>&1 || \
      die "kwriteconfig6 is required to configure Plasma Login Manager"

    if [[ -f /etc/plasmalogin.conf && ! -e /etc/plasmalogin.conf.before-hyprland ]]; then
      as_root cp -a -- /etc/plasmalogin.conf /etc/plasmalogin.conf.before-hyprland
    fi

    as_root kwriteconfig6 --file /etc/plasmalogin.conf \
      --group Greeter --key PreselectedSession "$session_file"
    as_root kwriteconfig6 --file /etc/plasmalogin.conf \
      --group Autologin --key Session "$session_file"
    ;;
  */sddm.service)
    command -v kwriteconfig6 >/dev/null 2>&1 || \
      die "kwriteconfig6 is required to configure SDDM"

    if [[ -f /etc/sddm.conf && ! -e /etc/sddm.conf.before-hyprland ]]; then
      as_root cp -a -- /etc/sddm.conf /etc/sddm.conf.before-hyprland
    fi

    as_root kwriteconfig6 --file /etc/sddm.conf \
      --group Autologin --key Session "${session_file%.desktop}"
    as_root install -d -m 0755 -o sddm -g sddm /var/lib/sddm
    as_root kwriteconfig6 --file /var/lib/sddm/state.conf \
      --group Last --key Session "$session_file"
    ;;
  *)
    die "unsupported display manager: ${display_manager:-none}"
    ;;
esac

log "Verifying installation"
hyprland_version=$(pacman -Q hyprland)
printf '%s\n' "$hyprland_version"
printf 'Session: %s\n' "/usr/share/wayland-sessions/$session_file"
printf 'Default configured in: %s\n' "$display_manager"

log "Installation complete"
printf 'Log out to the login screen; Hyprland (uwsm-managed) will be selected by default.\n'
printf 'Plasma remains installed and can still be selected from the session menu.\n'
