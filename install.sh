#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".bak.$(date +%Y%m%d-%H%M%S)"

if [[ ! -f "$ROOT/config/hypr/hyprland.conf" ]]; then
  printf 'Run this installer from a checkout containing config/hypr/hyprland.conf.\n' >&2
  exit 1
fi

confirm_step() {
  local title="$1" answer
  printf '\n== %s ==\n' "$title"
  read -r -p 'Run this step? [y/N] ' answer || true
  [[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]]
}

step() {
  local title="$1"
  shift
  if confirm_step "$title"; then
    "$@"
  else
    printf 'Skipped.\n'
  fi
}

install_packages() {
  sudo pacman -S --needed "$@"
}

copy_config() {
  local source="$1" target="$2" mode="${3:-644}"
  [[ -f "$ROOT/$source" ]] || { printf 'Missing staged file: %s\n' "$source" >&2; return 1; }
  if [[ -f "$target" ]] && cmp -s "$ROOT/$source" "$target"; then
    printf 'Already current: %s\n' "$target"
    return
  fi
  if [[ -e "$target" ]]; then
    cp -a -- "$target" "${target}${BACKUP_SUFFIX}"
    printf 'Backed up existing file to %s\n' "${target}${BACKUP_SUFFIX}"
  fi
  install -D -m "$mode" -- "$ROOT/$source" "$target"
  printf 'Installed %s\n' "$target"
}

copy_scripts() {
  local script
  install -d "$HOME/.local/bin"
  for script in "$@"; do
    copy_config "config/scripts/$script" "$HOME/.local/bin/$script" 755
  done
}

install_package_picker() {
  copy_config tools/arch-app-tui/src/arch-app-tui \
    "$HOME/.local/bin/arch-app-tui" 755
  copy_config config/applications/arch-app-tui.desktop \
    "$HOME/.local/share/applications/arch-app-tui.desktop"
}

copy_waybar() {
  copy_config config/waybar/config.jsonc "$HOME/.config/waybar/config.jsonc"
  copy_config config/waybar/style.css "$HOME/.config/waybar/style.css"
}

copy_idle_and_lock() {
  copy_config config/hypr/hypridle.conf "$HOME/.config/hypr/hypridle.conf"
  copy_config config/hypr/hyprlock.conf "$HOME/.config/hypr/hyprlock.conf"
}

printf 'Omarchy-to-Arch staged configuration installer\n'
printf 'Each step is optional. Nothing runs without a separate confirmation.\n'
printf 'Existing files are backed up before replacement.\n'

step 'Install Ghostty terminal' install_packages ghostty
step 'Install Fuzzel launcher' install_packages fuzzel
step 'Install Waybar status bar' install_packages waybar
step 'Install Mako notifications' install_packages mako
step 'Install Hypridle and Hyprlock' install_packages hypridle hyprlock
step 'Install audio, brightness, and media controls' install_packages brightnessctl playerctl wireplumber
step 'Install screenshot and recording tools' install_packages grim slurp wf-recorder wl-clipboard libnotify
step 'Install clipboard history dependency' install_packages cliphist
step 'Install internal-display helper dependency' install_packages jq
step 'Install network and Bluetooth tools' install_packages networkmanager bluez blueman
step 'Install power-profile daemon' install_packages power-profiles-daemon
step 'Install tmux' install_packages tmux
step 'Install office and PDF applications' install_packages libreoffice-fresh zathura zathura-pdf-mupdf
step 'Install fzf for the package picker' install_packages fzf

step 'Copy native Hyprland config (does not copy Lua config)' copy_config config/hypr/hyprland.conf "$HOME/.config/hypr/hyprland.conf"
step 'Copy Ghostty config' copy_config config/ghostty/config "$HOME/.config/ghostty/config"
step 'Copy Fuzzel config' copy_config config/fuzzel/fuzzel.ini "$HOME/.config/fuzzel/fuzzel.ini"
step 'Copy Waybar config and stylesheet' copy_waybar
step 'Copy Mako config' copy_config config/mako/config "$HOME/.config/mako/config"
step 'Copy Hypridle and Hyprlock configs' copy_idle_and_lock
step 'Copy screenshot and recording helpers' copy_scripts screenshot-region screenshot-full screen-record-toggle
step 'Copy clipboard picker' copy_scripts clipboard-picker
step 'Copy internal-display helper' copy_scripts toggle-internal-display
step 'Copy network and Bluetooth menus' copy_scripts network-menu bluetooth-menu
step 'Copy power-profile helper' copy_scripts power-profile-cycle
step 'Copy tmux config' copy_config config/tmux/tmux.conf "$HOME/.config/tmux/tmux.conf"
step 'Add the Install app to the launcher' install_package_picker

step 'Enable NetworkManager and Bluetooth services' sudo systemctl enable --now NetworkManager.service bluetooth.service
step 'Enable power-profiles-daemon service' sudo systemctl enable --now power-profiles-daemon.service

printf '\nThe lid policy can suspend the laptop when its lid closes, including on external power.\n'
step 'Install staged systemd lid policy' sudo install -Dm644 "$ROOT/config/systemd/logind.conf.d/20-lid.conf" /etc/systemd/logind.conf.d/20-lid.conf
step 'Restart systemd-logind to apply the lid policy (may interrupt the session)' sudo systemctl restart systemd-logind.service

printf '\nFinished. Review config/hypr/README.md for target-specific adjustments and Hyprland validation.\n'
