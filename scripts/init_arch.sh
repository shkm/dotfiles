#!/usr/bin/sh
set -e

dotfiles_dir="$HOME/.dotfiles/"
new_shell="/usr/bin/fish"

text_red=$(tput setaf 1)
text_green=$(tput setaf 2)
text_blue=$(tput setaf 3)
text_reset=$(tput sgr0)

trap "tput sgr0" 0

indent() { sed 's/^/   /g'; }

with_sudo() {
  sudo_prompt=$(echo "${text_reset}[sudo] password for %u: " | indent)

  sudo -p "${sudo_prompt}" $1 2>&1
}

download_dotfiles() {
  git clone --verbose --bare https://github.com/shkm/dotfiles.git "${dotfiles_dir}" 2>&1
  git --git-dir=${dotfiles_dir} --work-tree=$HOME config --local status.showUntrackedFiles no
  git --git-dir=${dotfiles_dir} --work-tree=$HOME checkout
}

download_packages() {
  with_sudo "pacman -S --noconfirm xclip neovim fish"
}

current_shell() {
  with_sudo "getent passwd $LOGNAME" | cut -d: -f7
}

change_shell() {
  with_sudo "chsh -s ${new_shell} $LOGNAME"
}

main() {
  echo "${text_green}1. Checking out dotfiles${text_reset}"

  if [ -d "${dotfiles_dir}" ]; then
    echo "${dotfiles_dir} already exists." | indent
  else
    download_dotfiles | indent
  fi
  
  echo "${text_green}2. Installing packages${text_reset}"
  download_packages | indent
  
  echo "${text_green}3. Changing shell to ${new_shell}${text_reset}"
  if [ "$(current_shell)" = "${new_shell}" ]; then
    echo "Shell is already set to ${new_shell}" | indent
  else
    change_shell | indent
  fi
}

main
