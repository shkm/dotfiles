# shkm's dotfiles

These are my dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

No promises are made about stability or portability, but feel free to use anything you find useful.

## Install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --source ~/dotfiles --apply shkm/dotfiles
```
