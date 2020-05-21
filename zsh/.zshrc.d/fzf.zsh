[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $XDG_CONFIG_HOME/fzf/zsh.zsh ] && source $XDG_CONFIG_HOME/fzf/zsh.zsh

export FZF_COMPLETION_TRIGGER=''
bindkey '^X^O' fzf-completion
bindkey '^I' $fzf_default_completion

# Dracula
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

ffd() {
  fd -t d . | fzf
}

fkill() {
  pid=$(ps -ef | sed 1d | fzf | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

fco() {
  git checkout $(git branch --format='%(refname:short)' | fzf)
}

# fssh - ssh into a host specified in ~/.ssh/config
# Takes an argument which will instead execute that command.
fssh() {
  local command="${1}"
  local host
  host=$(grep '^host .*' ~/.ssh/config | cut -d ' ' -f 2 | fzf)

  [ -z $host ] && return

  echo "Connecting to ${host}"
  [ -n $command ] && echo "Command: ${command}"

  ssh -t $host $command
}

fsshr() {
  fssh '/bin/bash -l -c "cd rails/current && bundle exec rails console"'
}

frsssh() {
  fssh '"${SHELL}" -l -c "bundle exec rails c -e staging"'
}

frpssh() {
  fssh '"${SHELL}" -l -c "bundle exec rails c -e production"'
}
