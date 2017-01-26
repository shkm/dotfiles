let $FZF_DEFAULT_COMMAND = 'ag -l -i -U -g ""'

" Ensure that esc closes fzf, even in a neovim terminal
autocmd FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

