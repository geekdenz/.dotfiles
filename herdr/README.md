# Herdr configuration

Run `./herdr/install.sh` to:

- link `~/.config/herdr/config.toml` to the tracked configuration;
- install or update Herdr's Codex integration;
- install or update Herdr's Cursor integration.

Runtime files such as logs, sockets, release notes, and `session.json` stay in
`~/.config/herdr` and are not tracked.

When Neovim runs inside a Herdr pane, the Avante bridge reports one `Avante`
agent row. The row underneath shows either `Codex ACP` or `Cursor ACP`, matching
the provider selected with `:AvanteSwitchProvider`.
