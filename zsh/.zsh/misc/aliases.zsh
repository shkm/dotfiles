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
alias scratch="vim $(mktemp -t scratch)"

# REPLs with Codi
alias rrepl='vim -c "set bt=nofile ls=0 noru nonu nornu ft=ruby | Codi ruby"'
alias jrepl='vim -c "set bt=nofile ls=0 noru nonu nornu | Codi javascript" $(mktemp -t codi.js) +cd .'


# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

