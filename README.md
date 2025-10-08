# :godmode: shkm's dotfiles

These are my dotfiles, managed with [GNU stow](https://www.gnu.org/software/stow/).

No promises are made about stability or portability, but feel free to use anything you find useful.

I primarily use the following right now:

- MacOS
- IntelliJ IDEs
- [Fish](https://fishshell.com/)
- [Zed](https://zed.dev)
- [Neovim](https://neovim.io/) with [Lazyvim](https://www.lazyvim.org)

## Setup (Mac)

Clone repo and run the scripts in `setup/macos`

## Bootstrapping Fish

I use `fisher` as my shell plugin manager, which itself is written in fish. Since fisher requires a list of bundles in my config, but running fish with my config and without fisher bundles causes it to explode, bootstrapping is a little tricky. This is what seems to work:

```
fish -c 'curl -sL https://git.io/fisher | source && fisher update'
```
