fenv source "$HOME/.profile"

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
