# arch-app-tui

A small interactive package picker for installing packages from Arch's official repositories or the AUR. It uses the existing `pacman` and `yay` commands; it does not install or configure either one.

## Requirements

- Arch Linux (or an Arch-based system)
- `pacman`
- `yay`
- `fzf` (`sudo pacman -S fzf`)

## Usage

```sh
./src/arch-app-tui
```

Choose a source, type to filter packages, use Tab to select multiple, then confirm before installation. Official packages are installed with `sudo pacman`; AUR packages with `yay`.

This initial version fetches the source's package-name list and does not yet show descriptions or installed status. No packages are installed until you confirm.
