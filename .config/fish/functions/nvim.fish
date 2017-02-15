function nvim --wraps nvim
  if set -q VIM
    echo 'VIMCEPTION'
  else
    nvim $argv;
  end
end
