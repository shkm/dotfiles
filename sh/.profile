export XDG_CONFIG_HOME="$HOME/.config"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

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

#Go
if [ -d "usr/local/go/bin" ]; then
  export PATH="/usr/local/go/bin:$PATH"
fi
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

DENO_INSTALL="${HOME}/.deno"
if [ -d "$DENO_INSTALL" ]; then
  export DENO_INSTALL
  export PATH="$PATH:$DENO_INSTALL/bin"
fi



# Dotnet
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
# if [ -n "$DESKTOP_SESSION" ];then
#   eval $(gnome-keyring-daemon --start)
#   export SSH_AUTH_SOCK
# fi

# Various telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Dotnet
export CHECKPOINT_DISABLE=1 # Prisma
export NEXT_TELEMETRY_DISABLED=1 # Next.js

# LESS colouring
export LESS_TERMCAP_mb=$(printf "\033[01;31m")
export LESS_TERMCAP_md=$(printf "\033[01;31m")
export LESS_TERMCAP_me=$(printf "\033[0m")
export LESS_TERMCAP_se=$(printf "\033[0m")
export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
export LESS_TERMCAP_ue=$(printf "\033[0m")
export LESS_TERMCAP_us=$(printf "\033[01;32m")

# FZF colours
# Material Palenight
# color00='#292D3E'
# color01='#444267'
# color02='#32374D'
# color03='#676E95'
# color04='#8796B0'
# color05='#959DCB'
# color06='#959DCB'
# color07='#FFFFFF'
# color08='#F07178'
# color09='#F78C6C'
# color0A='#FFCB6B'
# color0B='#C3E88D'
# color0C='#89DDFF'
# color0D='#82AAFF'
# color0E='#C792EA'
# color0F='#FF5370'

# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
# " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
# " --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
# " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

# One dark

color00='#282c34'
color01='#353b45'
color02='#3e4451'
color03='#545862'
color04='#565c64'
color05='#abb2bf'
color06='#b6bdca'
color07='#c8ccd4'
color08='#e06c75'
color09='#d19a66'
color0A='#e5c07b'
color0B='#98c379'
color0C='#56b6c2'
color0D='#61afef'
color0E='#c678dd'
color0F='#be5046'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
