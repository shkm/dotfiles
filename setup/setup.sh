#!/usr/bin/env bash
OS=$(cat /etc/os-release | grep "^ID=" | sed 's/^ID=//')

MONOSPACE_FONT="JetBrainsMono"
STOW_CONFIGS="asdf fish git jetbrains nvim scripts sh tig vim"

function packages() {
  printf "\n--> Installing packages for $OS\n"

  if [[ $OS = "fedora" ]]; then
    sudo dnf install -y openssl-devel zlib-devel \
      bat tig ripgrep stow git fzf exa fish fd-find \
      tilix zoxide papirus-icon-theme whois wl-clipboard
  elif [[ $OS = "ubuntu" ]]; then
    sudo apt install -y build-essential \
      bat tig ripgrep stow git fzf exa fish fd-find \
      tilix flatpak gnome-software-plugin-flatpak zoxide papirus-icon-theme \
      whois wl-clipboard
  fi
}

function dotfiles() {
  if [ ! -d "$HOME/dotfiles" ]; then
    printf "\n--> Fetching dotfiles\n"
    git clone https://github.com/shkm/dotfiles.git $HOME/dotfiles

    # We'll want to use SSH in future
    $(cd $HOME/dotfiles && git remote set-url origin git@github.com:shkm/dotfiles.git)
  fi
}

# If this script is executed "remotely" (piped into bash) we want to make sure we
# exit at this point and re-execute the local version
function execLocalSetup() {
  printf "\n\n--> Switching to local setup script"
  cd "$HOME/dotfiles"
  setup/setup.sh --bootstrapped
  exit
}

function stowDotfiles() {
  printf "\n\n--> Stowing dotfiles\n"
  stow -d "$HOME/dotfiles" -S $STOW_CONFIGS
}

function fonts() {
  printf "\n\n--> Installing fonts\n"
  if [ ! -d "$HOME/repos/nerd-fonts" ]; then
    mkdir -p "$HOME/repos" 2>/dev/null
    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git $HOME/repos/nerd-fonts
  fi

  $(cd $HOME/repos/nerd-fonts && git sparse-checkout add patched-fonts/$MONOSPACE_FONT)
  $($HOME/repos/nerd-fonts/install.sh -q $MONOSPACE_FONT)
}

function gsettings() {
  printf "\n\n--> Modifying gsettings\n"
  $HOME/dotfiles/setup/gsettings.sh
}

function neovim() {
  if ! command -v nvim &> /dev/null; then
    printf "\n\n--> Installing NeoVim (AppImage)\n"
  
    NVIM="/usr/local/bin/nvim"
    sudo wget --output-document="$NVIM" "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    sudo chmod +x "$NVIM"

    sudo update-alternatives --install /usr/bin/vi vi $NVIM 60
    sudo update-alternatives --install /usr/bin/vim vim $NVIM 60
    sudo update-alternatives --install /usr/bin/editor editor $NVIM 60
  fi
}

function asdf() {
  if [ ! -d "$HOME/.asdf" ]; then
    printf "\n\n--> Installing asdf\n"
  
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.11.3
  fi

  . "$HOME/.asdf/asdf.sh"

  if ! command -v ruby &> /dev/null; then
    printf "\n\n--> Installing Ruby via asdf\n"
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
    asdf install ruby latest
  fi

  if ! command -v npm &> /dev/null; then
    printf "\n\n--> Installing NodeJS via asdf\n"
    asdf install nodejs latest
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  fi

  asdf local ruby $(asdf list ruby | head)
  asdf local nodejs $(asdf list nodejs | head)
}

function npmPackages() {
  printf "\n\n--> Installing global NPM packages\n"

  npm install -g tldr
}

function flathub() {
  printf "\n\n--> Enabling FlatHub\n"

  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function flatpakPackages() {
  printf "\n\n--> Installing Flatpaks\n"
  flatpak install --noninteractive flathub org.signal.Signal
  flatpak install --noninteractive flathub com.spotify.Client
}

function changeShell() {
  local desiredShell=$(which fish)

  if [ ! $SHELL = $desiredShell ]; then
    printf "\n\n--> Changing shell\n"
    sudo usermod -s $desiredShell $USERNAME
  fi
}

function bootstrapFish() {
  fish -c 'curl -sL https://git.io/fisher | source 2>&1 && fisher update 2>&1'
}

function finished() {
  printf "\n\n--> All done!\n"
  echo "Manual next steps:"

  echo "  - Generate an SSH key"
  echo "  - Install Docker / Podman"
  echo "  - Logout and in"
}

function main() {
  # Special switches for bootstrap (remote) setup.
  if [[ "$1" = "--bootstrap" ]]; then
    packages
    dotfiles
    execLocalSetup

    exit
  elif [[ ! "$1" = "--bootstrapped" ]]; then
    packages
    dotfiles
  fi

  fonts
  gsettings
  stowDotfiles
  neovim
  asdf
  npmPackages
  flathub
  flatpakPackages
  changeShell
  bootstrapFish
  finished
}


main "$@"
