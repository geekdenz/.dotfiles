#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

run_case() {
  image=$1
  docker run --rm \
    --mount "type=bind,source=$repo_dir,target=/root/.dotfiles,readonly" \
    "$image" sh -eu -c '
      export HOME=/root
      "$HOME/.dotfiles/install.sh"
      "$HOME/.dotfiles/install.sh"
      test "$(readlink -f "$HOME/.zshrc")" = "$HOME/.dotfiles/shells/zshrc"
      test "$(readlink -f "$HOME/.local/bin/wl-copy")" = "$HOME/.dotfiles/bin/wl-copy"
      test "$(readlink -f "$HOME/.gnupg/gpg-agent.conf")" = "$HOME/.dotfiles/gnupg/gpg-agent.conf"
      command -v zsh
      zsh -n "$HOME/.zshrc"
      shell_output=$(TERM=xterm-256color zsh -i -c "printf interactive-zsh-ok" 2>&1)
      test "$shell_output" = interactive-zsh-ok
      test -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
      fc-list | grep -qi JetBrainsMono
    '
}

if (($#)); then
  for image in "$@"; do
    run_case "$image"
  done
else
  run_case debian:bookworm-slim
  run_case archlinux:base
fi
