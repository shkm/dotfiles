# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

# Nix package manager
# if [ -d "$HOME/.nix-profile" ] ; then
#   source "$HOME/.nix-profile/etc/profile.d/nix.sh"
# fi

# Ensure local/bin (homebrew stuff) is in path.
if [ -d "/usr/local/bin" ] ; then
  export PATH="/usr/local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/scripts" ] ; then
  export PATH="$HOME/scripts:$PATH"
fi

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="$HOME/go/bin:$PATH"
fi

if [ -d "$HOME/.cargo" ] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.dobbin/bin" ] ; then
  export PATH="$HOME/.dobbin/bin:$PATH"
fi

# Interactive only
if [ -t "0" ]; then
  if [ -f "$HOME/.secrets" ]; then
    source $HOME/.secrets
  fi
fi

# Locale
export LC_ALL="en_GB.UTF-8"

# Personal
export EMAIL="jamie@schembri.me"
export NAME="Jamie Schembri"
export SMTPSERVER="smtp.gmail.com"
export XDG_CONFIG_HOME="$HOME/.config"

# LESS colouring
export LESS_TERMCAP_mb=$(printf "\033[01;31m")
export LESS_TERMCAP_md=$(printf "\033[01;31m")
export LESS_TERMCAP_me=$(printf "\033[0m")
export LESS_TERMCAP_se=$(printf "\033[0m")
export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
export LESS_TERMCAP_ue=$(printf "\033[0m")
export LESS_TERMCAP_us=$(printf "\033[01;32m")

# RVM
[ -f /usr/share/rvm/scripts/rvm ] && source /usr/share/rvm/scripts/rvm
[ -f ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm
