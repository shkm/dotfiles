setlocal spell

function! GettextNextUnfilled()
  call search('""\n\n')
endfunction

function! GettextPreviousUnfilled()
  call search('""\n\n', 'b')
endfunction

nnoremap <buffer> <silent> ]n :call GettextNextUnfilled()<CR>
nnoremap <buffer> <silent> [n :call GettextPreviousUnfilled()<CR>
