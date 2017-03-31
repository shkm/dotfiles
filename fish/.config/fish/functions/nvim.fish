function nvim --wraps nvim
  if set -q VIM
    command nvr $argv
  else
    command nvim $argv
  end
end
