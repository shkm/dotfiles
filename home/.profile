export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export LANG=en_GB.UTF-8

if [ -d "${HOME}/dotfiles" ]; then
  export DOTFILES="${HOME}/dotfiles"
fi

# Put additional sources in ~/.profile.d/, not under VCS
if [ -d "$HOME/.profile.d" ]; then
  for f in $HOME/.profile.d/*.sh; do
    [ -e "$f" ] && source "$f"
  done
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
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv bash)"

  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ENV_HINTS=1
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

# Obsidian Mac
if [ -d "/Applications/Obsidian.app/Contents/MacOS" ]; then
  export PATH="/Applications/Obsidian.app/Contents/MacOS:$PATH"
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

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
if [ -d "$PNPM_HOME" ]; then
  export PATH="$PNPM_HOME/bin:$PATH"
fi

# bun
BUN_INSTALL="${HOME}/.bun"
if [ -d "$BUN_INSTALL" ]; then
  export BUN_INSTALL
  export PATH="$PATH:$BUN_INSTALL/bin"
fi

# Deno
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

# PHP
HERD_ROOT="$HOME/Library/Application Support/Herd/bin"
if [ -d "$HERD_ROOT" ]; then
  export PATH="$HERD_ROOT:$PATH"
  export PHP_INI_SCAN_DIR="$HERD_ROOT:$PHP_INI_SCAN_DIR"
fi

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 2048000"

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

# Disable various telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Dotnet
export CHECKPOINT_DISABLE=1          # Prisma
export NEXT_TELEMETRY_DISABLED=1     # Next.js
export RTK_TELEMETRY_DISABLED=1      # RTK

# LESS colouring
export LESS_TERMCAP_mb=$(printf "\033[01;31m")
export LESS_TERMCAP_md=$(printf "\033[01;31m")
export LESS_TERMCAP_me=$(printf "\033[0m")
export LESS_TERMCAP_se=$(printf "\033[0m")
export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
export LESS_TERMCAP_ue=$(printf "\033[0m")
export LESS_TERMCAP_us=$(printf "\033[01;32m")

# Theme variables (DARK_MODE, DARK_MODE_THEME, THEME, ...)
eval "$("$HOME/scripts/theme-env")"

# FZF colours from the active theme.
_fzf_opts_file="$HOME/.config/themes/$THEME/fzf.opts"
if [ -f "$_fzf_opts_file" ]; then
  FZF_DEFAULT_OPTS=$(cat "$_fzf_opts_file")
  export FZF_DEFAULT_OPTS
fi
unset _fzf_opts_file

# LS_COLORS: use non-bold palette indices so colours track the terminal
# palette (which itself is theme-aware via ghostty). Avoiding bold keeps
# directories readable on light backgrounds where the bright palette
# variants wash out.
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=33;40:cd=33;40:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:*.tar=31:*.tgz=31:*.zip=31:*.gz=31:*.bz2=31:*.xz=31:*.7z=31:*.deb=31:*.rpm=31:*.jpg=35:*.jpeg=35:*.gif=35:*.png=35:*.svg=35:*.bmp=35:*.tif=35:*.tiff=35:*.mov=35:*.mp4=35:*.mkv=35:*.webm=35:*.mp3=36:*.flac=36:*.ogg=36:*.wav=36:*.pdf=33:*.md=33:*.txt=33'
