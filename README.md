# Agent Usage for Arch Linux

Standalone Claude Code and OpenAI Codex usage collectors extracted from
Omarchy 4.0.4. The collectors report local token statistics and subscription
rate limits without requiring Omarchy or Quickshell.

## Requirements

- Arch Linux
- Python 3.10+
- Bash, jq, and systemd
- Claude Code and/or Codex CLI, signed in to the relevant account

Install base dependencies:

```bash
sudo pacman -S --needed python jq
```

## Install

```bash
chmod +x install.sh bin/*
./install.sh
```

The installer creates symlinks in `~/.local/bin`, installs a user-level
systemd timer, and performs the first collection. No root access is required.

Collected records are written to:

```text
~/.local/state/agent-usage/claude.json
~/.local/state/agent-usage/codex.json
```

Cached scans are stored under `~/.cache/agent-usage/`.

## Commands

```bash
# Refresh every available provider
agent-usage-update

# Refresh only one provider
agent-usage-update claude
agent-usage-update codex

# Ignore caches and refresh limits
agent-usage-update --force

# Inspect raw records
jq . ~/.local/state/agent-usage/claude.json
jq . ~/.local/state/agent-usage/codex.json

# Produce Waybar JSON
agent-usage-waybar
agent-usage-waybar --provider claude
```

Set `CLAUDE_CONFIG_DIR` or `CODEX_HOME` if either CLI uses a non-default data
directory.

## Waybar

Add this module to your Waybar configuration:

```jsonc
"custom/agent-usage": {
  "exec": "$HOME/.local/bin/agent-usage-waybar",
  "return-type": "json",
  "interval": 60,
  "tooltip": true,
  "on-click": "$HOME/.local/bin/agent-usage-update --force"
}
```

Then include `custom/agent-usage` in `modules-left`, `modules-center`, or
`modules-right`.

Optional CSS:

```css
#custom-agent-usage.warning { color: #f9e2af; }
#custom-agent-usage.critical { color: #f38ba8; }
```

## Authentication

Claude subscription limits require:

```bash
claude auth login
```

Codex limits require:

```bash
codex login
```

Local transcript statistics may still appear without a live sign-in. These
figures represent CLI subscription limits and local usage, not general OpenAI
or Anthropic API billing.

## Attribution

The Claude and Codex collector logic is derived from the Omarchy project:
<https://github.com/basecamp/omarchy>. Omarchy is licensed under the MIT
License. Portable wrapper, Waybar output, and installation files were added
for this standalone version.
