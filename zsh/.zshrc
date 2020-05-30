# zmodload zsh/zprof # profiling

# -- Basics --

autoload -Uz colors && colors
autoload -Uz edit-command-line && zle -N edit-command-line
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

setopt prompt_subst
setopt autocd             # change dir without cd
setopt no_case_glob       # case insensitive globbing
setopt printexitvalue     # for non-zero exits
setopt correct            # help with mistyped commands
setopt sharehistory       # share history across all shells
setopt histignorealldups  # filter dupes from history
setopt extended_history   # add timestamps and other info to history
setopt inc_append_history # add to history after every command
setopt hist_verify        # show substituted history command before executing

# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"

 # auto-show up to 1000 completion possibilities
LISTMAX=1000

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

# -- Mappings --

# Use standard emacs mappings
bindkey -e
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# -- Sources --

source "$HOME/.zshrc.d/fzf.zsh"
source "$HOME/.zshrc.d/antibody.zsh"
source "$HOME/.zshrc.d/aliases.zsh"
source "$HOME/.zshrc.d/functions.zsh"
source "$HOME/.zshrc.d/theme.zsh"
source "$HOME/.zshrc.d/asdf.zsh"

# zprof # profiling
