function _git_branch
  echo (command git rev-parse --abbrev-ref HEAD ^/dev/null)
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _pwd
  echo (dirs -0 | tr -d [:space:])
end

function _vi_mode_color
  switch $fish_bind_mode
  case default
    set_color red
  case insert
    set_color green
  case visual
    set_color magenta
  end
end

function fish_prompt
  echo -n -s (set_color blue) (_pwd)
  set -l prefix

  if [ (uname) = "Linux" ]
    set prefix ' ◈ '
  else
    set prefix ' ༄  '
  end
  echo -n -s (_vi_mode_color) $prefix

  set_color normal
end

function fish_right_prompt
  if [ (_git_branch) ]
    if [ (_git_is_dirty) ]
      echo -n -s (set_color red) '⁕' (set_color normal)
    end

    echo -n -s ' ' (set_color white) (_git_branch)
  end

  set_color normal
end
