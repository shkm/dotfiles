#autoload -Uz colors && colors
#autoload -Uz edit-command-line && zle -N edit-command-line

#setopt prompt_subst
#setopt autocd             # change dir without cd
#setopt no_case_glob       # case insensitive globbing
#setopt printexitvalue     # for non-zero exits
#setopt correct            # help with mistyped commands
#setopt sharehistory       # share history across all shells
#setopt histignorealldups  # filter dupes from history
#setopt extended_history   # add timestamps and other info to history
#setopt inc_append_history # add to history after every command
#setopt hist_verify        # show substituted history command before executing

# Use standard emacs mappings
#bindkey -e
#bindkey '^xe' edit-command-line
#bindkey '^x^e' edit-command-line

#alias vi="nvim"
#alias vim="nvim"
#alias v="nvim"
#alias v.="nvim ."
#alias scratch="vim $(mktemp -t scratch.XXX.md)"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

source /Users/jamie/.config/broot/launcher/bash/br

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
