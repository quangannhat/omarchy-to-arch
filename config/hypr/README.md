# Hyprland

This is the first standalone port from the local vanilla Omarchy setup.

## Install

```sh
mkdir -p ~/.config/hypr
cp config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
```

The config intentionally uses native Hyprland syntax and does not depend on
Omarchy Lua modules, `omarchy-*` commands, or the Omarchy shell. Set the
`$terminal` and `$fileManager` variables at the top to match the applications
installed on the target system. `Super + Space` launches Fuzzel's application
search.

Install Ghostty and copy its configuration:

```sh
sudo pacman -S ghostty
mkdir -p ~/.config/ghostty
cp config/ghostty/config ~/.config/ghostty/config
```

Hyprland and Fuzzel use Ghostty as the terminal. Install Fuzzel and copy its
configuration alongside Hyprland:

```sh
sudo pacman -S fuzzel
mkdir -p ~/.config/fuzzel
cp config/fuzzel/fuzzel.ini ~/.config/fuzzel/fuzzel.ini
```

The top bar is Waybar and starts from Hyprland's `exec-once` entry. Install it
and copy the two Waybar files with:

```sh
sudo pacman -S waybar
mkdir -p ~/.config/waybar
cp config/waybar/config.jsonc config/waybar/style.css ~/.config/waybar/
```

Notifications are handled by Mako. Install it and copy the notification
configuration with:

```sh
sudo pacman -S mako
mkdir -p ~/.config/mako
cp config/mako/config ~/.config/mako/config
```

The notification shortcuts are `Super + Comma` to dismiss the latest,
`Super + Shift + Comma` to dismiss all, and `Super + Ctrl + Comma` to toggle
do-not-disturb mode.

Idle and locking use `hypridle` and `hyprlock`. Install them and copy the
configs with:

```sh
sudo pacman -S hypridle hyprlock
cp config/hypr/hypridle.conf ~/.config/hypr/hypridle.conf
cp config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf
```

The session locks after five minutes, turns the display off after five and a
half minutes, and suspends after thirty minutes. `Super + Ctrl + L` locks
immediately.

Hardware controls use PipeWire's `wpctl`, `brightnessctl`, and `playerctl`:

```sh
sudo pacman -S brightnessctl playerctl wireplumber
```

Volume, mute, brightness, and media keys are defined directly in
`hyprland.conf` and remain available while the screen is locked.

Screenshots and screen recording use `grim`, `slurp`, `wf-recorder`,
`wl-clipboard`, and `libnotify`:

```sh
sudo pacman -S grim slurp wf-recorder wl-clipboard libnotify
mkdir -p ~/.local/bin
cp config/scripts/screenshot-region config/scripts/screenshot-full \
  config/scripts/screen-record-toggle ~/.local/bin/
chmod +x ~/.local/bin/screenshot-region ~/.local/bin/screenshot-full \
  ~/.local/bin/screen-record-toggle
```

Use `Print Screen` for a selected region, `Shift + Print Screen` for the full
screen, and `Alt + Print Screen` to start or stop recording.

Clipboard history uses `cliphist` with the existing Wayland clipboard tools:

```sh
sudo pacman -S cliphist
cp config/scripts/clipboard-picker ~/.local/bin/clipboard-picker
chmod +x ~/.local/bin/clipboard-picker
```

Use `Super + Ctrl + V` to search clipboard history with Fuzzel. Text and image
clipboard entries are collected automatically while the session is running.

The internal display can be toggled with `Super + Ctrl + Delete`. The helper
discovers the internal `eDP-*` output at runtime, so it does not depend on the
current machine's monitor identifier:

```sh
sudo pacman -S jq
cp config/scripts/toggle-internal-display ~/.local/bin/toggle-internal-display
chmod +x ~/.local/bin/toggle-internal-display
```

Network and Bluetooth controls use native Arch tools:

```sh
sudo pacman -S networkmanager bluez blueman
cp config/scripts/network-menu config/scripts/bluetooth-menu ~/.local/bin/
chmod +x ~/.local/bin/network-menu ~/.local/bin/bluetooth-menu
```

`Super + Ctrl + W` opens NetworkManager's `nmtui`; `Super + Ctrl + B` opens
Blueman. Clicking the Waybar network or Bluetooth module opens the same tools.
Enable and start the relevant system services on the target installation as
part of its normal system setup.

Power profiles use `power-profiles-daemon`:

```sh
sudo pacman -S power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon.service
cp config/scripts/power-profile-cycle ~/.local/bin/power-profile-cycle
chmod +x ~/.local/bin/power-profile-cycle
```

`Super + Ctrl + P` cycles through power-saver, balanced, and performance. The
current profile is also shown in Waybar.

The staged `config/systemd/logind.conf.d/20-lid.conf` suspends on lid close,
including on external power, and ignores lid events while docked. Apply it only
after reviewing the policy for the target laptop:

```sh
sudo install -Dm644 config/systemd/logind.conf.d/20-lid.conf \
  /etc/systemd/logind.conf.d/20-lid.conf
sudo systemctl restart systemd-logind.service
```

Tmux is configured separately and does not depend on Omarchy:

```sh
sudo pacman -S tmux
mkdir -p ~/.config/tmux
cp config/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

The port keeps the current `Ctrl + S` prefix, vi copy mode, pane/window/session
bindings, and status bar. The Omarchy-specific keybinding help command has been
replaced with native `tmux list-keys` output.

For office documents and PDF files, install LibreOffice and the lightweight
Zathura PDF viewer:

```sh
sudo pacman -S libreoffice-fresh zathura zathura-pdf-mupdf
```

The current laptop defaults are represented by `monitor = , preferred, auto,
auto`, `GDK_SCALE=2`, and `caps:escape`. Replace the monitor line with an
explicit output, mode, position, and scale when adding a second display.
