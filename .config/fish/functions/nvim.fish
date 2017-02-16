function nvim --wraps nvim
  if set -q VIM
    echo 'VIMCEPTION'
  else
    command nvim $argv
  end
end
