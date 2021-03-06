export XDG_CONFIG_HOME="$HOME/.config"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

if [ -f "$HOME/.secrets" ] ; then
  source "$HOME/.secrets"
fi

# Ensure local/bin is in path.
if [ -d "/usr/local/bin" ] ; then
  export PATH="/usr/local/bin:$PATH"
fi

# Misc user bins
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Misc user bins
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi

# Dasht
if [ -d "$HOME/repos/dasht" ] ; then
  export PATH="$HOME/repos/dasht/bin:$PATH"
fi

# Version-controlled scripts
if [ -d "$HOME/scripts" ] ; then
  export PATH="$HOME/scripts:$PATH"
fi

# Go
if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="$HOME/go/bin:$PATH"
fi

# Rust
if [ -d "$HOME/.cargo" ] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Yarn
if [ -d "$HOME/.yarn/bin" ] ; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

# Mblaze
export MBLAZE="$XDG_CONFIG_HOME/mblaze/profile"

# Scripts
export SCRIPT_PATH="$HOME/scripts"

# EDITOR
export EDITOR='nvim'

# Not a fan
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# LESS colouring
export LESS_TERMCAP_mb=$(printf "\033[01;31m")
export LESS_TERMCAP_md=$(printf "\033[01;31m")
export LESS_TERMCAP_me=$(printf "\033[0m")
export LESS_TERMCAP_se=$(printf "\033[0m")
export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
export LESS_TERMCAP_ue=$(printf "\033[0m")
export LESS_TERMCAP_us=$(printf "\033[01;32m")

# Bat
if command -v bat &> /dev/null; then
  export BAT_THEME="Nord"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ssh / gnome keyring
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
