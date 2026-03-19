# shkm's dotfiles

No promises are made about stability or portability, but feel free to use anything you find useful.

## Structure

```
home/           Symlinked into ~
setup/
  run             Main entry point (symlinks, shell, packages, plugins, macOS defaults)
  symlinks        Create/update symlinks from home/ into ~
  macos-defaults  macOS system preferences
Brewfile        Homebrew packages
```

Plugins (fish, bat themes) are managed as git submodules under `home/`.

## Vivaldi

Custom CSS mods live in `home/.config/vivaldi-mods/`. After setup, point **Settings → Appearance → Custom UI Modifications** to `~/.config/vivaldi-mods`.

## Install

```sh
git clone --recursive git@github.com:shkm/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup/run
```

Setup scripts can also be run individually:

```sh
./setup/symlinks        # re-link dotfiles only
./setup/macos-defaults  # apply macOS defaults only
```
