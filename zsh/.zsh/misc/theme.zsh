function __git_dirty() {
  # changes
  if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
    echo '*'
    return
  fi
  # untracked files
  if [[ $(git status --porcelain 2>/dev/null | grep "^??") != "" ]]; then
    echo '⁂'
    return
  fi
}

function __git_branch() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -z "${branch}" ]]; then return; fi

  local colour="black"
  local bold=true

  case $branch in
    staging)
      colour="red"
      bold=true
      ;;
    production)
      colour="red"
      bold=false
      ;;
  esac

  local colour_command
  if [ "$bold" = true ]; then
    colour_command="$fg_bold[${colour}]"
  else
    colour_command="$fg[${colour}]"
  fi

  echo " %{${colour_command}${branch}%{$reset_color%}"
}

PROMPT='\
%{$fg[blue]%}%~%{$reset_color%}\
$(__git_branch)$(__git_dirty)
%{$fg[cyan]%}> \
%{$reset_color%}\
'
