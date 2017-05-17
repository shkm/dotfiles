function docker-shell -d "Opens a bash shell in the given docker container"
  docker run -it --entrypoint /bin/bash $argv[1]
end
