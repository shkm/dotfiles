#!/usr/bin/env bash
sudo pacman -S --noconfirm --needed yaourt stow zsh tig ripgrep tmux xclip fzf \
  neovim python2-neovim python-neovim \
  go

mkdir ~/bin

go get antibody

if [ ! -e ~/dotfiles ]; then
  git clone https://github.com/shkm/dotfiles.git ~/dotfiles
  rm ~/.bash_profile # probably already exists, so remove before stowing
  stow -d ~/dotfiles ag alacritty autokey bash eslint git scripts tig tmux vim zsh
fi

chsh -s /usr/bin/zsh

