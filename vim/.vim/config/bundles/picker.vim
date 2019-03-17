call plug#load('vim-picker')

call picker#Register('vim', 'file', 'edit', 'fd . --extension .vim $HOME/.vim')
call picker#Register('dotfiles', 'file', 'edit', 'fd . $HOME/dotfiles -H')
call picker#Register('zsh', 'file', 'edit', 'fd . $HOME/.zsh')
call picker#Register('directories', 'file', 'edit', 'fd -t d')
