# My dotfiles

## One-shot Linux installation

The installer supports Debian/Ubuntu and Arch/Omarchy/CachyOS. It installs Zsh, Oh My
Zsh, Powerlevel10k, JetBrainsMono Nerd Font, clipboard dependencies, and links
the maintained configuration into the current user's home directory.

```bash
git clone https://github.com/example-user/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
exec zsh
```

It is safe to rerun. Existing managed links are retained; conflicting files are
moved to timestamped `before-dotfiles-*` backups before links are created.

The installer detects `apt-get` and `pacman` automatically. On non-root systems
it uses `sudo` for package installation and changing the default shell.

## CachyOS Hyprland installation

For the complete CachyOS desktop setup, including Hyprland, Waybar, OCR
capture, daily random wallpapers, no-gap tiled windows, and the persistent
SSH agent, run:

```bash
~/.dotfiles/install.sh
~/.dotfiles/install-hyprland-cachyos.sh
```

The SSH agent uses one per-user socket and loads the first available default
key (`id_ed25519`, `id_rsa`, or `id_example`) from the first interactive shell.
Enter its passphrase once per login session; subsequent terminals and GUI apps
reuse the loaded key.

## What it configures

- Zsh, Oh My Zsh, Powerlevel10k, and `~/.p10k.zsh`
- JetBrainsMono Nerd Font
- Neovim, Git, tmux, IdeaVim, WezTerm, ctags, and agignore links
- Herdr configuration and an OSC 52 `wl-copy` bridge for remote sessions
- GPG terminal pinentry through `pinentry-curses`
- A persistent per-user OpenSSH agent service
- Machine-specific values loaded from an ignored `.env` file and rendered into
  local Git and Remmina configuration
- The current Hyprland configuration when installing on Omarchy
- WezTerm as the default terminal on Omarchy

## Testing

Run the idempotency and installation checks against Debian and Arch containers:

```bash
~/.dotfiles/tests/install-docker.sh
```

## Shell-only linking

To link only the existing shell files without installing packages:

```bash
~/.dotfiles/shells/setup.sh
```
