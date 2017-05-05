" Remap 0 to ^ (first char in line)
map 0 ^

" Switch ;/: for easier command entry.
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :

" Split gf
nnoremap gvf :vertical wincmd f<CR>
nnoremap gsf <C-w>f

" Expand snippets on C-l
imap <expr><C-l> "\<Plug>(neosnippet_expand_or_jump)"

" Easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Search with grepper in visual/normal mode
nmap gs <plug>(GrepperOperator)
vmap gs <plug>(GrepperOperator)

" Tmux / vim window navigation
nnoremap <silent> <c-h> :call TmuxPane('h')<CR>
nnoremap <silent> <c-j> :call TmuxPane('j')<CR>
nnoremap <silent> <c-k> :call TmuxPane('k')<CR>
nnoremap <silent> <c-l> :call TmuxPane('l')<CR>
