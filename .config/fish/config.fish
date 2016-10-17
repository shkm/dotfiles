# Sources
if test -e $HOME/.secrets; and status --is-interactive
  source $HOME/.secrets
end

if test -e /usr/local/share/chruby/chruby.fish
  source /usr/local/share/chruby/chruby.fish
  source /usr/local/share/chruby/auto.fish
end

# Exports
if test -d $HOME/go
  set -x GOPATH $HOME/go
  set -gx PATH $GOPATH/bin $PATH
end

if test -d $HOME/bin
  set -gx PATH $HOME/bin $PATH 
end

# Locale
set -x LC_ALL "en_GB.UTF-8"

# Personal details
set -x EMAIL "jamie@schembri.me"
set -x NAME "Jamie Schembri"
set -x SMTPSERVER "smtp.gmail.com"

# Misc
set -x MANPAGER "/bin/sh -c \"col -b | nvim -c 'set ft man nomod nolist nonu noma' -\""

# No greeting
set --erase fish_greeting

# Vi mode
fish_vi_key_bindings
