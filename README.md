# :godmode: shkm's dotfiles

These are my dotfiles, managed using [GNU stow](https://www.gnu.org/software/stow/). They're designed for me and subject to change at any time, but feel free to take bits and pieces.

Over the years I've used some pretty esoteric setups; nowadays I'm more focused on Getting Shit Done, and as a result my dotfiles are becoming more spartan.

Current setup involves this software amongst others:

- Fedora, Ubuntu
- IntelliJ IDEs
- [Neovim](https://neovim.io/)
- [Fish](https://fishshell.com/)

## Bootstrapping
```
curl -sL https://raw.githubusercontent.com/shkm/dotfiles/master/setup/setup.sh | bash -s -- --bootstrap
```

## Bootstrapping Fish

I use `fisher` as my shell plugin manager, which itself is written in fish. Since fisher requires a list of bundles in my config, but running fish with my config and without fisher bundles causes it to epxlode, bootstrapping is a little tricky. This is what seems to work:

```
fish -c 'curl -sL https://git.io/fisher | source && fisher update'
```
