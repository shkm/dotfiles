#!/usr/bin/env bash
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed yaourt stow zsh tig ripgrep tmux xclip neovim python2-neovim python-neovim go tree

mkdir ~/bin 2>/dev/null

go get github.com/getantibody/antibody

if [ ! -e ~/dotfiles ]; then
  git clone https://github.com/shkm/dotfiles.git ~/dotfiles
  rm .profile ~/.bash_profile ~/.Xresources 2>/dev/null # probably already exists, so remove before stowing
  stow -d ~/dotfiles ag alacritty autokey bash eslint git scripts tig tmux vim zsh kde x autokey sh ruby
fi

if ! command -v diff-highlight > /dev/null; then
  sudo easy_install diff-highlight
fi

[ "$SHELL" = '/usr/bin/zsh' ] || chsh -s /usr/bin/zsh

