set termguicolors " truecolour
set inccommand=split " Show results of commands incrementally

" Fix tmux navigation
" See https://github.com/neovim/neovim/issues/2048
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

" --
" Terminal
" --

" Split movement
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

tnoremap <ESC> <C-\><C-n> " Easier normal mode (ESC)
