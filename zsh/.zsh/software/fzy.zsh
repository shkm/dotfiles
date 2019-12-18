ffd() {
  fd -t d . | fzy
}

fkill() {
  pid=$(ps -ef | sed 1d | fzy | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

fco() {
  git checkout $(git branch --format='%(refname:short)' | fzy)
}

# fssh - ssh into a host specified in ~/.ssh/config
# Takes an argument which will instead execute that command.
fssh() {
  local command="${1}"
  local host
  host=$(grep '^host .*' ~/.ssh/config | cut -d ' ' -f 2 | fzy)

  [ -z $host ] && return

  echo "Connecting to ${host}"
  [ -n $command ] && echo "Command: ${command}"

  ssh $host $command
}

frsssh() {
  fssh '"${SHELL}" -l -c "bundle exec rails c -e staging"'
}

frpssh() {
  fssh '"${SHELL}" -l -c "bundle exec rails c -e production"'
}

zstyle :fzy:file command rg --files

bindkey '^R'  fzy-history-widget
bindkey '^T'  fzy-file-widget
bindkey '\ec' fzy-cd-widget
