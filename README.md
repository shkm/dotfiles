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

Each theme is a single-mode (dark *or* light) directory at
`home/.config/themes/<name>/` with palette files for bat, delta, fish,
fzf, ghostty, lazygit, nvim, and oh-my-posh. Two symlinks pick the
actives, one per mode:

```
themes/active-dark  -> tokyonight-storm
themes/active-light -> tokyonight-day
```

Dark and light are independent — mix and match across families.

```sh
theme-switch              # show actives + list by mode (* marks active)
theme-switch <name>       # set the matching mode (MODE comes from env.sh)
theme-colors              # preview terminal palette + fish syntax colours
```

Variant follows macOS appearance automatically. To add a new theme,
copy an existing dir, edit `env.sh` (set `MODE`, `THEME`,
`BAT_THEME`, `FISH_THEME`, `GHOSTTY_THEME`), and drop in the per-tool
files. The matching bat/fish theme files go in `home/.config/bat/themes/`
and `home/.config/fish/themes/`.

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
