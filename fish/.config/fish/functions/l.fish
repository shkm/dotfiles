function l --wraps exa
  if command --search exa
    exa --long --git $argv
  else
    ls -lsa $argv
  end
end

