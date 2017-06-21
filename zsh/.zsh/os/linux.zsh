if ! [ $(uname) = "Linux" ]; then exit 0; fi

if ! type "apt-get" > /dev/null; then
  alias ppa="sudo apt-add-repository"
fi
