# Temp fix for https://github.com/fish-shell/fish-shell/issues/3876
# Change when upgrading to fish 2.6+
set -q XTERM_VERSION; or set -gx XTERM_VERSION 0

# Bundles
source $HOME/.config/fish/bundles/init.fish

# Mappings
source $HOME/.config/fish/mappings/fzf.fish
# Exports
if test -d $HOME/go
  set -x GOPATH $HOME/go
  set -gx PATH $GOPATH/bin $PATH
end

if test -d $HOME/.linuxbrew
  set -gx PATH $HOME/.linuxbrew $PATH
end

if test -d $HOME/bin
  set -gx PATH $HOME/bin $PATH 
end

if test -d $HOME/.gem/ruby/2.4.0
  set -gx PATH $HOME/.gem/ruby/2.4.0/bin $PATH
end

if test -d $HOME/.cargo/bin
  set -gx PATH $HOME/.cargo/bin $PATH
end

if test -d $HOME/.fzf/bin
  set -gx PATH $HOME/.fzf/bin $PATH
end

if not set -q XDG_CONFIG
  set -gx XDG_CONFIG $HOME/.config
end


# Locale
set -x LC_ALL "en_GB.UTF-8"

# Personal details
set -x EMAIL "jamie@schembri.me"
set -x NAME "Jamie Schembri"
set -x SMTPSERVER "smtp.gmail.com"

# Preferences
set -x EDITOR "nvim"

# GPG agent
set -x GPG_TTY (tty)

# Misc
# LESS colouring
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")

# No greeting
set --erase fish_greeting

# Vi mode
fish_hybrid_key_bindings

# No default vi-mode mode indicator
function fish_mode_prompt; end
