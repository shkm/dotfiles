function dcb() {
  docker-compose exec -it $1 /bin/bash
}

function cdd() {
  cd $(dirname $1)
}

function dopen() {
  open $(dirname $1)
}
