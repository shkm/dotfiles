source $HOME/.zsh/init/exports.zsh
source $HOME/.zsh/misc/mappings.zsh
source $HOME/.zsh/init/antibody.zsh
source $HOME/.zsh/init/basics.zsh
# source $HOME/.zsh/init/title.zsh

if [[ `uname` = 'Darwin' ]]; then source $HOME/.zsh/os/osx.zsh; fi
if [[ `uname` =  'Linux' ]]; then source $HOME/.zsh/os/linux.zsh; fi

source $HOME/.zsh/software/chruby.zsh
source $HOME/.zsh/language/ruby.zsh

source $HOME/.zsh/software/tmux.zsh
source $HOME/.zsh/software/emacs.zsh
source $HOME/.zsh/software/vim.zsh
source $HOME/.zsh/software/git.zsh
source $HOME/.zsh/software/vagrant.zsh
source $HOME/.zsh/software/fzf.zsh
source $HOME/.zsh/software/mpc.zsh

source $HOME/.zsh/misc/aliases.zsh

source $HOME/.zsh/work/development.zsh
source $HOME/.zsh/work/deployment.zsh

source $HOME/.zsh/misc/theme.zsh
