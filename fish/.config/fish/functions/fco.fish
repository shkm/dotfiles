function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | ag -v HEAD | string trim | fzf | xargs git checkout
end

