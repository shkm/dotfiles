" search related docsets
nnoremap <Leader>ks :Dasht<Space>

" search ALL the docsets
nnoremap <Leader>Ks :Dasht!<Space>

" search related docsets
nnoremap <silent> <Leader>kh :call Dasht(dasht#cursor_search_terms())<Return>

" search ALL the docsets
nnoremap <silent> <Leader>Kh :call Dasht(dasht#cursor_search_terms(), '!')<Return>

" search related docsets
vnoremap <silent> <Leader>k y:<C-U>call Dasht(getreg(0))<Return>

" search ALL the docsets
vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0), '!')<Return>

let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp

" For example: {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

  " When in Elixir, also search Erlang:
  let g:dasht_filetype_docsets['ruby'] = ['Ruby', 'Ruby_on_Rails_6']

  let g:dasht_filetype_docsets['html'] = ['css', 'js', 'bootstrap']
  let g:dasht_filetype_docsets['haml'] = ['css', 'js', 'bootstrap']

" and so on... }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
