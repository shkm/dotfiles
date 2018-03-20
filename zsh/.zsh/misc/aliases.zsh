# vim: foldmethod=marker:

alias c="clear"
alias pcp="rsync --progress -ah"
alias tailf="less +F -R"
alias ll="exa -lga"
alias lsd="ls -lsah | lolcat"
alias sha256="shasum -a 256"
alias sha1="openssl sha1"
alias download="curl -LO#"
alias sz="source ~/.zshrc"
alias ag='ag --path-to-ignore=~/.agignore'
alias ssh_key="cat ~/.ssh/id_rsa.pub | pbcopy; echo 'Copied SSH key to clipboard.'"
alias ducks="du -cksh * | sort -hr"
alias myip='curl ifconfig.co'
alias docker-eval='eval "$(docker-machine env)"'
alias gbd="git branch | grep -v \* | xargs -I {} git branch -d {} ; git branch"
alias gbD="git branch | grep -v \* | xargs -I {} git branch -D {} ; git branch"
alias vms="vboxmanage list runningvms"
alias lico="licommander"
alias genpass="openssl rand -base64 24"
alias scratch="vim $(mktemp --suffix _scratch.md)"

# REPLs with Codi
alias rrepl="vim $(mktemp --suffix _codi.rb) +Codi ruby +cd ."
alias jrepl="vim $(mktemp --suffix _codi.js) +Codi javascript +cd ."


# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

