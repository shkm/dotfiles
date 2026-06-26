# shkm's dotfiles

No promises are made about stability or portability, but feel free to use anything you find useful.

New scripts and setup code are mostly written by LLM. They're quick to write and only have to support my particular setup, which turns out leads me to a better experience than using off-the-shelf tools like chezmoi.

The canonical location of these dotfiles is now [Tangled.org](https://tangled.org/jamie.schembri.me/dotfiles). GitHub contains a mirror.

## Structure

```
home/           Symlinked into ~
setup/
  run                   Main entry point (symlinks, shell, packages, plugins, macOS defaults)
  symlinks              Create/update symlinks from home/ into ~
  macos-defaults.d/     Declarative macOS defaults (dsully/macos-defaults YAML format)
Brewfile        Homebrew packages
```

Plugins (fish, bat themes) are managed as git submodules under `home/`.

## Themes

Each theme is a self-contained directory at `home/.config/themes/<name>/`
with palette files for bat, delta, fish, fzf, ghostty, lazygit, nvim,
and oh-my-posh. The `themes/active` symlink picks the active one.

```sh
theme-switch              # list themes; * marks the active one
theme-switch <name>       # switch (rebuilds bat cache, signals ghostty to reload)
theme-colors              # preview terminal palette + fish syntax colours
```

Dark/light follows macOS appearance automatically. To add a new theme,
copy an existing dir and edit `env.sh` plus the per-tool files.

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
./setup/symlinks                              # re-link dotfiles only
macos-defaults apply ./setup/macos-defaults.d/  # apply macOS defaults only
```
