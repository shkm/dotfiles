function mime --wraps file
  file --mime-type -b $argv
end
