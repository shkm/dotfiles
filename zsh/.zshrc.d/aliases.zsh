# General
alias pcp="rsync --info=progress -ah"
alias tailf="less +F -R"
alias ls="exa -lga --group-directories-first"
alias ll="ls"
alias sha256="shasum -a 256"
alias sha1="openssl sha1"
alias fetch="curl -LO#"
alias sz="source $HOME/.zshrc"
alias sshkey="clip $HOME/.ssh/id_ed25519.pub && echo 'Copied SSH key to clipboard.'"
alias ducks="du -cksh * | sort -hr"
alias myip='curl ifconfig.co'
alias genpass="openssl rand -base64 24"
alias n="nnn"
alias lg="lazygit"
alias cat="bat"
alias ca="cat"
alias ssh-fingerprint="ssh-keygen -E md5 -lf"
alias serve="python -m http.server"
alias ssh="TERM=xterm ssh" # kitty has issues

alias vi="nvim"
alias vim="nvim"
alias v="nvim"
alias v.="nvim ."
alias scratch="vim $(mktemp -t scratch.XXX.md)"

# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

# Most git aliases are in ~/.gitconfig.
alias g='git'
alias gcd='cd $(git rev-parse --show-toplevel)'

alias dex="docker exec -it"
alias dc="docker-compose"
alias dka="docker kill $(docker ps -q)"
alias rg="rg --ignore-file $HOME/.ignore"
