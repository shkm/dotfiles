setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Don't match parameters. This was slowing vim down considerably.
let loaded_matchparen = 1

" Compile/run ruby
nmap <leader>cr :!ruby %<CR>

" We want conceals to work in ruby.
setlocal conceallevel=2

" ri lookup of local gems
" Depends on the vri executable and AnsiEsc
function! RubyRiLookup(term)
  let output = system('vri --no-pager -f ansi ' . a:term)
  new | put =output
  nnoremap <buffer> q :bd<CR>

  execute "normal! gg"
  setlocal nonumber buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  \ nomodifiable statusline=ri nocursorline nofoldenable
  AnsiEsc
endfunction

command! -nargs=1 RubyDoc call RubyRiLookup(<f-args>)
setlocal keywordprg=:RubyDoc

