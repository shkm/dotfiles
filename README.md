# :godmode: shkm's dotfiles

These are my dotfiles. They're managed using [GNU stow](https://www.gnu.org/software/stow/).

If you think I can improve something, a pull request is appreciated! If you're not sure what something does, feel free to open an issue.

## Packages

This is a list of some packages that I use; many of which are expected or required by dotfiles.

| Tool/Package                                           | Description                               | Required/Expected by                |
|--------------------------------------------------------|-------------------------------------------|-------------------------------------|
| [Firefox](mozilla.org/firefox/)                        | Browser                                   | scripts (firefox-work)              |
| [Flameshot](https://github.com/lupoDharkael/flameshot) | Screenshot tool                           | i3 (key binding)                    |
| [GNU Stow](https://www.gnu.org/software/stow/)         | Dotfiles manager                          | dotfiles                            |
| [Neovim](https://neovim.io/)                           | A modern fork of vim                      | aliases, profile                    |
| [alacritty](https://github.com/alacritty/alacritty)    | Fast, GPU-based terminal emulator         | i3 (terminal commands use alacritty |
| [antibody](https://github.com/getantibody/antibody)    | zsh package manager                       | zsh                                 |
| [asdf-vm](https://asdf-vm.com/#/)                      | Tool version manager                      | zsh (not required)                  |
| [bat](https://github.com/sharkdp/bat)                  | `cat` alternative                         | aliases (cat)                       |
| [delta](https://github.com/delta-io/delta)             | Syntax-highlighted differ                 | git (git diff)                      |
| [docker-compose](https://github.com/docker/compose)    | It's docker-compose                       | aliases (dcb)                       |
| [docker](https://www.docker.com/)                      | It's docker                               | aliases (dex)                       |
| [exa](https://github.com/ogham/exa)                    | `cd` alternative                          | aliases (ll, ls, tree)              |
| [fd](https://github.com/sharkdp/fd)                    | `find` alternative                        | zsh (fzf)                           |
| [feh](https://github.com/derf/feh)                     | Image viewer with background capabilities | i3, scripts (refresh-wallpaper      |
| [fzf](https://github.com/junegunn/fzf)                 | Fuzzy finder                              | neovim, zsh (aliases, key bindings  |
| [git](https://git-scm.com/)                            | It's git                                  | dotfiles, aliases, tig, etc.        |
| [i3-blocks](https://github.com/vivien/i3blocks)        | Provides widgets for the i3 bar           | i3-gaps                             |
| [i3-gaps](https://github.com/Airblader/i3)             | Tiling window manager                     | none
| [ripgrep](https://github.com/BurntSushi/ripgrep)       | `grep` alternative                        | fzf (optional), neovim              |
| [rofi](https://github.com/davatorium/rofi)             | Program launcher                          | i3 (key binding)                    |
| [tig](https://jonas.github.io/tig/)                    | Git TUI                                   | none                                |
| [tmux](https://github.com/tmux/tmux)                   | Terminal multiplexer                      | aliases (tma, tmks)                 |
| [xclip](https://linux.die.net/man/1/xclip)             | Cilpboard manager                         | scripts (clip) *Linux only          |
| [z](https://github.com/agkozak/zsh-z)                  | zsh directory jumper                      | none                                |
| [zip](https://linux.die.net/man/1/zip)                 | (De)compression utility                   | aliases (zipdir)                    |
| [zsh](https://www.zsh.org/)                            | A better shell                            | aliases, profile, zsh               |
