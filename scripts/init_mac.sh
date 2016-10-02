#!/usr/bin/env sh

echo "~~> Installing homebrew…"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "~~> Installing brew packages…"
$(brew install \
  git\
  zsh\
  neovim/neovim/neovim\
  shkm/brew/vssh\
  mas\
  diff-so-fancy\
)

echo "~~> Installing cask brew packages…"
$(brew cask install \
  google-chrome\
  dropbox\
  alfred\
  hipchat\
  caskroom/versions/iterm2-beta\
  virtualbox\
  vagrant\
  chruby\
  ruby-build\
  caskroom/fonts/font-hasklig\
  caskroom/fonts/font-fira-code\
)

echo "~~> Grabbing dotfiles…"
git clone --bare https://github.com/shkm/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no



