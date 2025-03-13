export XDG_CONFIG_HOME="$HOME/.config"
export LANG=en_GB.UTF-8

# Put additional sources in ~/.profile.d/, not under VCS
if [ -d "$HOME/.profile.d" ]; then
  for f in "$HOME/.profile.d/*.sh"; do source $f; done
fi

# See https://wiki.archlinux.org/title/GNOME/Keyring
if [ -f "${XDG_RUNTIME_DIR}/gcr/ssh" ]; then
  # Newer method.
  # Requires that `gcr-ssh-agent` is running for the user:
  # systemctl --user enable --now gcr-ssh-agent
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gcr/ssh"
elif [ -f "${XDG_RUNTIME_DIR}/keyring/ssh" ]; then
  # Older method.
  # Uses `gnome-keyring` daemon.
  # systemctl --user status gnome-keyring
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/keyring/ssh"
fi

# Homebrew
BREW_ROOT="/opt/homebrew/bin"
if [ -d "$BREW_ROOT" ]; then
  export PATH="$BREW_ROOT:$PATH"
fi

# Ensure local/bin is in path.
if [ -d "/usr/local/bin" ]; then
  export PATH="/usr/local/bin:$PATH"
fi

# Misc user bins
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Misc user bins
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# Version-controlled scripts
export SCRIPT_PATH="$HOME/scripts"
if [ -d "$SCRIPT_PATH" ]; then
  export PATH="$SCRIPT_PATH:$PATH"
fi

# Go
if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="$HOME/go/bin:$PATH"
fi

# Rust
if [ -d "$HOME/.cargo" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Yarn
if [ -d "$HOME/.yarn/bin" ]; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
if [ -d "$NPM_PACKAGES" ]; then
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
if [ -d "$DOTNET_ROOT" ]; then
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
if command -v bat &>/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -plman'"
  export MANROFFOPT="-c"
fi

# ssh / gnome keyring
# if [ -n "$DESKTOP_SESSION" ];then
#   eval $(gnome-keyring-daemon --start)
#   export SSH_AUTH_SOCK
# fi

# Various telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Dotnet
export CHECKPOINT_DISABLE=1          # Prisma
export NEXT_TELEMETRY_DISABLED=1     # Next.js

# LESS colouring
export LESS_TERMCAP_mb=$(printf "\033[01;31m")
export LESS_TERMCAP_md=$(printf "\033[01;31m")
export LESS_TERMCAP_me=$(printf "\033[0m")
export LESS_TERMCAP_se=$(printf "\033[0m")
export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
export LESS_TERMCAP_ue=$(printf "\033[0m")
export LESS_TERMCAP_us=$(printf "\033[01;32m")

# FZF colours
# Catppuccin-Latte
export FZF_DEFAULT_OPTS=" \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

# Catppuccin-Mocha
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
