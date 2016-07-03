# vim: foldmethod=marker:

# --- Functions {{{
# Search and play.
# `mpc_search_play type query`
mpc_search_play() {
  if (($# < 2)) then
    echo "Usage: mpc_search_play <type> <query>"
  else
    $type = $1
    $query = $2

    mpc clear
    mpc search $1 $2 | mpc add
    mpc play
  fi
}
# }}}

# --- Aliases {{{
alias mas="mpc search albumartist"
alias ma="mpc_search_play albumartist"
alias mr="mpc search album"
alias mrs="mpc_search_play album"
# }}}

