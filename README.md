# Dotfiles

## Summary

These are my dotfiles. They were created using the [bare git repo method](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) (though I've opted for ~/.dotfiles over ~/.cfg) in order to sidestep the whole symlink nonsense. 

## Requirements

- git

## Installation

There's a simple init script for Arch. It doesn't do everything, but it's a start.

```
curl -s https://raw.githubusercontent.com/shkm/dotfiles/master/.setup/init_arch.sh | sh
```
