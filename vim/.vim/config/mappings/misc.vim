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
" imap <expr><C-l> "\<Plug>(neosnippet_expand_or_jump)"

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'

" Easy-align
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

" coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
