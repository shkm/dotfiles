fenv source "$HOME/.profile"

# Disable greeting
set -U fish_greeting

# Tide
set -U hydro_symbol_prompt '>'
set -U hydro_multiline true
set -U hydro_symbol_git_dirty '*'
set -U hydro_symbol_git_ahead '↑'
set -U hydro_symbol_git_behind '↓'
set -U hydro_color_pwd grey
set -U hydro_color_git green
set -U hydro_color_error red
set -U hydro_color_prompt cyan
set -U hydro_color_duration grey

# FZF's legacy keybindings conflict with Fish
set -U FZF_LEGACY_KEYBINDINGS 0

# asdf
set -l asdfPath "$HOME/.asdf/asdf.fish"
test -f $asdfPath; and source $asdfPath

abbr cat bat
abbr dc docker-compose
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
