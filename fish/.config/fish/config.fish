fenv source "$HOME/.profile"

# Disable greeting
set -U fish_greeting

# FZF's legacy keybindings conflict with Fish
set -U FZF_LEGACY_KEYBINDINGS 0

# mise
if test -f "$HOME/.local/bin/mise"
  $HOME/.local/bin/mise activate fish | source
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
abbr be bundle exec

zoxide init fish | source

if type -q "oh-my-posh"
  oh-my-posh init fish --config "$HOME/.config/oh-my-posh/catppuccin_mocha.omp.json" | source
end

# Bindings
bind \cX edit_command_buffer
