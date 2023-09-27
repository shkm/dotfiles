fenv source "$HOME/.profile"

# Disable greeting
set -U fish_greeting

# FZF's legacy keybindings conflict with Fish
set -U FZF_LEGACY_KEYBINDINGS 0

# asdf
if test -f "$HOME/.asdf/asdf.fish"
  source "$HOME/.asdf/asdf.fish"
else if test -f "/opt/homebrew/opt/asdf/libexec/asdf.fish"
  source "/opt/homebrew/opt/asdf/libexec/asdf.fish"
end

abbr cat bat
abbr dc docker compose
abbr dka "docker kill (docker ps -q)"
abbr ducks "du -cksh * | sort -hr"
abbr g git
abbr gcd "cd (git rev-parse --show-toplevel)"
abbr ll exa -lga --group-directories-first
abbr ls ll
abbr sshkey "clip $HOME/.ssh/id_ed25519.pub"
abbr rm trash
abbr v nvim
abbr v. "nvim ."
abbr vim nvim

zoxide init fish | source

if type -q "oh-my-posh"
  oh-my-posh init fish --config "$HOME/.config/oh-my-posh/theme.omp.json" | source
end
