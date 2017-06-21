alias tm="tmux"
alias tmks="tmux kill-server"

function tmn() {
  tmux new -s "$*"
}

function tma() {
  tmux attach-session -t "$*"
}

function tmks() {
  tmux kill-session -t "$*"
}
