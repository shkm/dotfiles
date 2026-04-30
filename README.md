# shkm's dotfiles

No promises are made about stability or portability, but feel free to use anything you find useful.

New scripts and setup code are mostly written by LLM. They're quick to write and only have to support my particular setup, which turns out leads me to a better experience than using off-the-shelf tools like chezmoi.

The canonical location of these dotfiles is now [Tangled.org](https://tangled.org/jamie.schembri.me/dotfiles). GitHub contains a mirror.

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

Custom CSS mods live in `home/.config/vivaldi-mods/`. Point **Settings → Appearance → Custom UI Modifications** to `.config/vivaldi-mods`.

## Install

```sh
git clone --recursive git@tangled.org:jamie.schembri.me/dotfiles ~/dotfiles
cd ~/dotfiles
./setup/run
```

Setup scripts can also be run individually:

```sh
./setup/symlinks        # re-link dotfiles only
./setup/macos-defaults  # apply macOS defaults only
```
