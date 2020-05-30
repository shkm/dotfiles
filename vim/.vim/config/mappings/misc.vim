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

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
map g= <Plug>(EasyAlign)

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

" List tags if more than one on jump
nnoremap <C-]> g<C-]>

" " coc
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" nnoremap <silent> K :call <SID>show_documentation()<CR>
" function! s:show_documentation()
"   if &filetype == 'vim'
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
