#!/usr/bin/env bash

# Homebrew
if ! command -v "brew" >/dev/null 2>&1; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew stuff is in path
BREW_ROOT="/opt/homebrew/bin"
if [ -d "$BREW_ROOT" ]; then
  export PATH="$BREW_ROOT:$PATH"
fi

# Install everything from Brewfile
DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
echo "Installing from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Stow dotfiles
# Auto-detect stow packages (directories not starting with _ or .)
STOW_PACKAGES=()
for dir in "$DOTFILES_DIR"/*/; do
  pkg=$(basename "$dir")
  [[ "$pkg" == _* || "$pkg" == .* ]] && continue
  STOW_PACKAGES+=("$pkg")
done

echo "Stowing dotfiles..."
for pkg in "${STOW_PACKAGES[@]}"; do
  # Check for existing config that would conflict
  first_subdir=$(find "$DOTFILES_DIR/$pkg" -mindepth 1 -maxdepth 1 -type d | head -1)
  if [ -n "$first_subdir" ]; then
    target="$HOME/$(basename "$first_subdir")"
  else
    target="$HOME/$(ls "$DOTFILES_DIR/$pkg" | head -1)"
  fi

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    read -rp "  $target already exists. Delete and stow $pkg? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      rm -rf "$target"
    else
      echo "  Skipping $pkg"
      continue
    fi
  fi

  echo "  Stowing $pkg"
  stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
done

# Install fisher and fish plugins
if command -v fish >/dev/null 2>&1; then
  if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    echo "Installing fisher..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  fi
  echo "Installing fish plugins..."
  fish -c "fisher update"
fi

# Set macOS defaults
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
read -rp "Apply macOS defaults (Finder, Dock, keyboard, etc.)? [y/N] " apply_defaults
if [[ "$apply_defaults" =~ ^[Yy]$ ]]; then
  bash "$SCRIPT_DIR/defaults.sh"
fi

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

echo "Done!"
