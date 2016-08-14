# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="$HOME/go/bin:$PATH"
fi

# Locale
export LC_ALL="en_GB.UTF-8"

# Allow use of C-s
stty -ixon

# Personal
export EMAIL="jamie@schembri.me"
export NAME="Jamie Schembri"
export SMTPSERVER="smtp.gmail.com"

# vim as manpager
# export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' \
#     -c 'nnoremap i <nop>' \
#     -c 'nnoremap I <nop>' \
#     -c 'nnoremap a <nop>' \
#     -c 'nnoremap A <nop>' \
#     -c 'nnoremap <Space> <C-f>' \
#     -c 'noremap q :quit<CR>' -"

# Manage ruby with chruby for bash/zsh
if [ -a /usr/local/opt/chruby/share/chruby/chruby.sh ] && [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  chruby $(cat ~/.ruby-version)
fi
