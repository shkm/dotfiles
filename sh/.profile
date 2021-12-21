export XDG_CONFIG_HOME="$HOME/.config"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
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

# Version-controlled scripts
export SCRIPT_PATH="$HOME/scripts"
if [ -d "$SCRIPT_PATH" ] ; then
  export PATH="$SCRIPT_PATH:$PATH"
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

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
if [ -d "$NPM_PACKAGES" ] ; then
  export PATH="$PATH:$NPM_PACKAGES/bin"
  export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
fi

# Dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
DOTNET_ROOT="$HOME/.dotnet"
if [ -d "$DOTNET_ROOT" ] ; then
  export DOTNET_ROOT
  export PATH="$DOTNET_ROOT:$PATH"
  export PATH="$DOTNET_ROOT/tools:$PATH"
fi

# EDITOR
export EDITOR='nvim'

# Rootless docker
if [ -f "${XDG_RUNTIME_DIR}/docker.sock" ]; then
  export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
fi

# Bat
if command -v bat &> /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ssh / gnome keyring
if [ -n "$DESKTOP_SESSION" ];then
  eval $(gnome-keyring-daemon --start)
  export SSH_AUTH_SOCK
fi

# LESS colouring
export LESS_TERMCAP_mb=$(printf "\033[01;31m")
export LESS_TERMCAP_md=$(printf "\033[01;31m")
export LESS_TERMCAP_me=$(printf "\033[0m")
export LESS_TERMCAP_se=$(printf "\033[0m")
export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
export LESS_TERMCAP_ue=$(printf "\033[0m")
export LESS_TERMCAP_us=$(printf "\033[01;32m")

# FZF colours (Material Palenight)
# Material Palenight
color00='#292D3E'
color01='#444267'
color02='#32374D'
color03='#676E95'
color04='#8796B0'
color05='#959DCB'
color06='#959DCB'
color07='#FFFFFF'
color08='#F07178'
color09='#F78C6C'
color0A='#FFCB6B'
color0B='#C3E88D'
color0C='#89DDFF'
color0D='#82AAFF'
color0E='#C792EA'
color0F='#FF5370'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
