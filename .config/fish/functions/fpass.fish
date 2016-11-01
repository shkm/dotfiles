function fpass -d "Fuzzy-find a Lastpass entry and copy the password"
  lpass ls | fzf | string replace -r -a '.+\[id: (\d+)\]' '$1' | xargs lpass show -c --password
end

