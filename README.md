# :godmode: shkm's dotfiles

These are my dotfiles. They've changed a lot over the years and will probably continue to change.

They're managed using [GNU stow](https://www.gnu.org/software/stow/). They're designed for me and subject to change at any time, but feel free to take bits and pieces.

I primarily use the following right now:

- MacOS
- IntelliJ IDEs
- [Neovim](https://neovim.io/) with [Lazyvim](https://www.lazyvim.org)
- [Fish](https://fishshell.com/)

## Setup (Mac)

Clone repo and run the scripts in `setup/macos`

## Bootstrapping Fish

I use `fisher` as my shell plugin manager, which itself is written in fish. Since fisher requires a list of bundles in my config, but running fish with my config and without fisher bundles causes it to explode, bootstrapping is a little tricky. This is what seems to work:

```
fish -c 'curl -sL https://git.io/fisher | source && fisher update'
```
