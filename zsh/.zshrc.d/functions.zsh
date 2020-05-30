function dcb() {
  docker-compose exec -it $1 /bin/bash
}

function cdd() {
  cd $(dirname $1)
}

function zipdir() {
  zip -r "$1.zip" $1
}
compdef _dirs zipdir