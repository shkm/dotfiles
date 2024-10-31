#!/usr/bin/env bash

# Homebrew
if ! command -v "brew" > /dev/null 2>&1; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew stuff is in path
BREW_ROOT="/opt/homebrew/bin"
if [ -d "$BREW_ROOT" ] ; then
  export PATH="$BREW_ROOT:$PATH"
fi


if ! command -v "mas" > /dev/null 2>&1; then
  echo "Installing mas"
  brew install mas
fi

echo "Installing MAS apps"

# bitwarden
mas install 1352778147

# wireguard
mas install 1451685025

# todoist
mas install 585829637

# home assistant
mas install 1099568401

echo "Installing general brew formulae"
brew install fish stow git zoxide nvim eza ripgrep ffmpeg bat httpie tig fzf fd jq fx delta jandedobbeleer/oh-my-posh/oh-my-posh

# Add fish to shells if it isn't already there
if ! grep -Fxq "/opt/homebrew/bin/fish" /etc/shells; then
  echo "Adding fish to global shells list"
  echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
fi

# make sure my user shell is fish
if [ "$SHELL" != "/opt/homebrew/bin/fish" ]; then
  echo "Setting user shell to fish"
  chsh -s /opt/homebrew/bin/fish
fi

echo "Installing casks"
brew install --cask signal iterm2 alfred jetbrains-toolbox font-jetbrains-mono-nerd-font zed itsycal chatgpt arc spotify obsidian shottr rectangle


echo "Done! Consider running defaults.sh to set default settings."
