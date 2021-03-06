if [ -d /usr/share/fzf/shell ]; then
  source /usr/share/zsh/site-functions/fzf
  source /usr/share/fzf/shell/key-bindings.zsh
elif [ -d /usr/share/fzf ]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
elif [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif [ -f $XDG_CONFIG_HOME/fzf/zsh.zsh ]; then
  source $XDG_CONFIG_HOME/fzf/zsh.zsh
fi

export FZF_COMPLETION_TRIGGER=''
bindkey '^X^O' fzf-completion
bindkey '^I' $fzf_default_completion

# Nord
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#     --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
#     --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
#     --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
#     --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

# Night Owl
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#a1aab8,bg:#011627,hl:#f78c6c
    --color=fg+:#d6deeb,bg+:#0e293f,hl+:#f78c6c
    --color=info:#ecc48d,border:#2c3043,prompt:#82aaff,pointer:#ff5874
    --color=marker:#f78c6c,spinner:#21c7a8,header:#092236'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

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
