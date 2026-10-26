# Agent Guidelines

## Project Purpose

`omarchy-to-arch` ports useful behavior from a mostly vanilla Omarchy setup to
a regular Arch Linux installation. The target should use upstream Arch
packages and native configuration formats wherever practical.

## Important Context

- The repository is the source of truth for the ported configuration.
- The current machine is running Omarchy and is useful as a reference system.
- Files under `~/.config/` are the live system and must not be changed unless
  the user explicitly asks to apply a staged configuration.
- Omarchy's packaged files under `/usr/share/omarchy/` are read-only reference
  material. Never edit them.
- Prefer native tools over Omarchy commands in the target configuration.
- The user's current setup is close to vanilla Omarchy; avoid inventing custom
  preferences without asking.

## Porting Rules

- Keep staged files under `config/`, organized by application.
- Use native Hyprland `.conf` syntax for the standalone target. Do not copy
  Omarchy's Lua module tree or depend on `omarchy-*` commands.
- Preserve behavior before appearance: input, monitors, window management,
  launchers, notifications, idle, locking, and hardware controls come first.
- Make package requirements explicit in `config/hypr/README.md`.
- Keep commands configurable when the target application is not guaranteed;
  use variables near the top of the relevant config.
- Do not install packages, copy files into the home directory, reload the live
  compositor, or change system services without explicit user approval.
- Do not commit secrets, machine-specific credentials, or blindly copied
  monitor identifiers.

## Current Port

The staged configuration currently covers:

- Hyprland compositor settings and core bindings
- Fuzzel application launcher
- Waybar status bar
- Mako notifications
- Hypridle idle handling
- Hyprlock screen locking
- PipeWire, brightness, and media-key bindings

The staged configuration is not automatically applied to the live system.

## Workflow

1. Inspect the existing Omarchy config and the relevant packaged defaults.
2. Identify the behavior to preserve and its Omarchy-specific dependencies.
3. Add the standalone configuration under `config/`.
4. Document packages, copy commands, and target-specific adjustments.
5. Validate before reporting completion.
6. Clearly state whether changes are staged only or applied to the live system.

## Validation

For Hyprland changes, run:

```sh
hyprland --verify-config --config config/hypr/hyprland.conf
git diff --check
```

For changes involving live Hyprland files, only after explicit approval, also
run `hyprctl reload` and then `hyprctl configerrors`.

For other daemons, validate with their installed command if available. If a
package is not installed, state that validation was limited to static review.

## Next Porting Areas

After the current desktop session components are settled, consider:

- Screenshot and screen recording tools
- Clipboard management
- Display and monitor switching
- Bluetooth and network interaction
- Power profiles and laptop lid behavior
- Theme and terminal configuration

Choose one area at a time and keep each change independently testable.
