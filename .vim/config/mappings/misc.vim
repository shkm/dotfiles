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

" Backspace clears search highlighting
nnoremap <silent><BS> :noh<CR>

" Fuzzy find files
noremap <C-p> :Files<CR>

" Autocomplete / snippets
" TAB:   v
" S-TAB: ^
" C-l:   expand snippet
" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-n>" :
"       \ deoplete#mappings#manual_complete()
" imap <C-l> <Plug>(neosnippet_expand_or_jump)
imap <Tab> <Plug>(neosnippet_expand_or_jump)

" Open autocompletion, navigate up and down.
inoremap <silent><expr> <C-j>
      \ pumvisible() ? "\<C-n>" :
      \ "<C-x><C-o>"
inoremap <C-k> <C-p>

" Center search results
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
