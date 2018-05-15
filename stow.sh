#!/usr/bin/env bash
#
# Stows my stuff.
# This script's purpose is to keep a record of what I stow across platforms,
# and provide a quick method to stow packages under specific fonditions.

set -o errexit
set -o pipefail

readonly PACKAGES=( ag alacritty bash eslint git ruby scripts sh tig tmux vim zsh )
readonly MACOS_PACKAGES=( macos )
readonly LINUX_PACKAGES=( linux autokey )


install () {
  local name="${1}"
  local -a packages=("${!2}")

  if [ ${#packages[@]} -ne 0 ]; then
    printf "$(tput setaf 6)%s:$(tput sgr0)\n" "${name}"
    for package in "${packages[@]}"; do printf "  %s\n" "${package}"; done

    stow "${packages[@]}";
  fi
}

general () {
  install "General" PACKAGES[@]
}

macos () {
  if [ "$(uname)" = 'Darwin' ]; then
    install "MacOS" MACOS_PACKAGES[@]
  fi
}

linux () {
  if [ "$(uname)" = 'Linux' ]; then
    install "Linux" LINUX_PACKAGES[@]
  fi
}

main () {
  general
  macos
  linux
}

main "$@"
