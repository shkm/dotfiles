set fisher_path (dirname (status current-filename))/../_plugins

# Disable greeting
set -U fish_greeting

# FZF's legacy keybindings conflict with Fish
set -U FZF_LEGACY_KEYBINDINGS 0

# A place to put transient settings that shouldn't be versioned
if test -f $HOME/.transient/fish.fish
    source $HOME/.transient/fish.fish
end
