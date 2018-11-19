function zipdir() {
  zip -r "$1.zip" $1
}
compdef _dirs zipdir

