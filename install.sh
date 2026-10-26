#!/bin/bash
set -euo pipefail

ROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
BIN_DIR="${HOME}/.local/bin"
SYSTEMD_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

mkdir -p "$BIN_DIR" "$SYSTEMD_DIR"

for command in agent-usage-claude agent-usage-codex agent-usage-update agent-usage-waybar; do
  ln -sfn "$ROOT/bin/$command" "$BIN_DIR/$command"
done

install -m 0644 "$ROOT/systemd/agent-usage.service" "$SYSTEMD_DIR/agent-usage.service"
install -m 0644 "$ROOT/systemd/agent-usage.timer" "$SYSTEMD_DIR/agent-usage.timer"

systemctl --user daemon-reload
systemctl --user enable --now agent-usage.timer
"$BIN_DIR/agent-usage-update" --force

printf 'Installed agent usage tools in %s\n' "$BIN_DIR"
printf 'Waybar command: %s\n' "$BIN_DIR/agent-usage-waybar"
