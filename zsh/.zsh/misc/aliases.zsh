# vim: foldmethod=marker:

alias c="clear"
# alias -="cd -"
alias pcp="rsync --progress -ah"
alias tailf="less +F -R"
alias ll="exa -lga --group-directories-first"
alias sha256="shasum -a 256"
alias sha1="openssl sha1"
alias download="curl -LO#"
alias sz="source ~/.zshrc"
alias ag='ag --path-to-ignore=~/.agignore'
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy; echo 'Copied SSH key to clipboard.'"
alias ducks="du -cksh * | sort -hr"
alias myip='curl ifconfig.co'
alias docker-eval='eval "$(docker-machine env)"'
alias gbd="git branch | grep -v \* | xargs -I {} git branch -d {} ; git branch"
alias gbD="git branch | grep -v \* | xargs -I {} git branch -D {} ; git branch"
alias vms="vboxmanage list runningvms"
alias lico="licommander"
alias genpass="openssl rand -base64 24"
alias scratch="vim $(mktemp -t scratch.XXX.md)"
alias ls="ls -lshaG"
alias lg="lazygit"
alias cat="bat"
alias ssh-fingerprint="ssh-keygen -E md5 -lf"

# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

