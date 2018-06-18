# Reasonable prompt
autoload -Uz colors && colors

setopt prompt_subst
# setopt autocd             # . / ..
setopt printexitvalue     # for non-zero exits
setopt histignorealldups  # filter dupes from history
setopt sharehistory       # share history across all shells

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# Make completion:
# - Case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
