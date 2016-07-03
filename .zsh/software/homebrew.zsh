# vim: foldmethod=marker:

# --- Aliases {{{
# Homebrew is available on OS X and Linux (as Linuxbrew).
alias bi="brew install"
alias br="brew uninstall"
alias bu="brew upgrade"
alias bs="brew search"

# Brew cask is only available on OS X.
if [[ `uname` = 'Darwin' ]]; then
  alias bci="brew cask install"
  alias bcr="brew cask uninstall"
  alias bcs="brew cask search"
fi
# }}}
