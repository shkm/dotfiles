" TODO: check location, set rtp
set rtp+=/usr/local/opt/fzf

let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!.git/*"'

" Ensure that esc closes fzf, even in a neovim terminal
autocmd FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

