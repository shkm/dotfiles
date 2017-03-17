function gemtags --description 'Generate ctags for gems in .gems'
  ctags --options=NONE --languages=ruby --exclude=.git --exclude=examples --exclude=test --exclude=spec -f gemtags -R .gems
end
