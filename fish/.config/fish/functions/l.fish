function l --wraps exa
  if command --search exa
    exa --long --git
  else
    ls -lsa
  end
end

