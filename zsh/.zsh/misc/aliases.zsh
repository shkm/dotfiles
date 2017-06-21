# vim: foldmethod=marker:

alias c="clear"
alias pcp="rsync --progress -ah"
alias tailf="less +F -R"
alias ll="ls -lsah"
alias lsd="ls -lsah | lolcat"
alias sha256="shasum -a 256"
alias sha1="openssl sha1"
alias download="curl -LO#"
alias sz="source ~/.zshrc"
alias ag='ag --path-to-ignore=~/.agignore'
alias ssh_key="cat ~/.ssh/id_rsa.pub | pbcopy; echo 'Copied SSH key to clipboard.'"
alias ducks="du -cksh * | gsort -hr"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias myip='curl ifconfig.co'
alias mux='tmuxinator'
alias docker-eval='eval "$(docker-machine env)"'

# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

