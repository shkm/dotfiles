# vim: foldmethod=marker:

# --- Aliases {{{
# Most git aliases are in ~/.gitconfig.
alias g='git'
alias ggpush='git push -u origin $(current_branch)'
alias gbr='git branch | grep -v \* | xargs -I {} git branch -d {} ; gb'
alias gbR='git branch | grep -v \* | xargs -I {} git branch -D {} ; gb'
alias gcd='cd $(git rev-parse --show-toplevel)'
# }}}
