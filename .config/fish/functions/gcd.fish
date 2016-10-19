function gcd -d 'cd up to closest git repo'
  cd (git rev-parse --show-toplevel)
end
