function pcp -d "cp with progress"
  rsync --progress -ah $argv;
end
