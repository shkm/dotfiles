# vim: foldmethod=marker:

alias c="clear"
# alias -="cd -"
alias pcp="rsync --progress -ah"
alias tailf="less +F -R"
alias ls="exa -lga --group-directories-first"
alias ll="exa -lga --group-directories-first"
alias sha256="shasum -a 256"
alias sha1="openssl sha1"
alias download="curl -LO#"
alias sz="source ~/.zshrc"
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy; echo 'Copied SSH key to clipboard.'"
alias ducks="du -cksh * | sort -hr"
alias myip='curl ifconfig.co'
alias docker-eval='eval "$(docker-machine env)"'
alias gbd="git branch | grep -v \* | xargs -I {} git branch -d {} ; git branch"
alias gbD="git branch | grep -v \* | xargs -I {} git branch -D {} ; git branch"
alias vms="vboxmanage list runningvms"
alias genpass="openssl rand -base64 24"
alias scratch="vim $(mktemp -t scratch.XXX.md)"
alias v="vim"
alias v.="vim ."
alias n="nnn"
alias lg="lazygit"
alias cat="bat"
alias ssh-fingerprint="ssh-keygen -E md5 -lf"
alias serve="python -m SimpleHTTPServer"
alias ssh-add-token="ssh-add -e /usr/lib/ssh-keychain.dylib 2>/dev/null ; ssh-add -s /usr/lib/ssh-keychain.dylib -t 8h"

alias csdp="SKIP_DATA_SYNC_CONFIRM=true cap staging db:pull"
alias cpdp="SKIP_DATA_SYNC_CONFIRM=true cap production db:pull"

# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

cdd() {
  cd $(dirname $1)
}
