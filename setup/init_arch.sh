#!/usr/bin/env bash
sudo pacman -S --noconfirm --needed yaourt stow zsh tig ripgrep tmux xclip \
  neovim python2-neovim python-neovim \
  go

mkdir ~/bin 2>/dev/null

go get github.com/getantibody/antibody

if [ ! -e ~/dotfiles ]; then
  git clone https://github.com/shkm/dotfiles.git ~/dotfiles
  rm ~/.bash_profile 2>/dev/null # probably already exists, so remove before stowing
  stow -d ~/dotfiles ag alacritty autokey bash eslint git scripts tig tmux vim zsh
fi

if ! command -v diff-highlight > /dev/null; then
  sudo easy_install diff-highlight
fi

[ "$SHELL" = '/usr/bin/zsh' ] || chsh -s /usr/bin/zsh

