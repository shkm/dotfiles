#~ vim: foldmethod=marker:

# --- Sources {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}


# --- Exports {{{
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# export FZF_DEFAULT_OPTS='
# --color fg:4,bg:0,hl:6,fg+:6,bg+:10,hl+:9
# --color info:13,prompt:11,spinner:2,pointer:1,marker:7
# '

# }}}


# --- Functions {{{
# fd
# Find directory from root.
fd() {
  local dir

  dir=$(find ${1:-*} -path '*/\.*' -prune \
    -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

# fkill
# Find and kill process.
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

# fbr - checkout git branch (including remote branches)
fco() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# repos - change dir to a repo in ~/repos
repos() {
  local dir
  dir=$(ls -F ~/repos | grep / | fzf)
  cd ~/repos/${dir}
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

  ssh $host $command
}
# }}}
