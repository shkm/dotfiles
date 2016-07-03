setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Don't match parameters. This was slowing vim down considerably.
let loaded_matchparen = 1

if exists(":Tabularize")
  " Align hashes.
  nmap <buffer> <leader>ah :Tabularize /\w:\zs/r0l1l0<CR>
  vmap <buffer> <leader>ah :Tabularize /\w:\zs/r0l1l0<CR>

  " Align symbols.
  nmap <buffer> <leader>as :Tabularize /:\h\+,* */l0<CR>
  vmap <buffer> <leader>as :Tabularize /:\h\+,* */l0<CR>
endif

" Compile/run ruby
nmap <leader>cr :!ruby %<CR>

" Run inline
nmap <leader>cm <Plug>(xmpfilter-mark)
nmap <leader>cc <Plug>(xmpfilter-run)
xmap <leader>cm <Plug>(xmpfilter-mark)
xmap <leader>cc <Plug>(xmpfilter-run)
nmap <leader>ca <Plug>(xmpfilter-clean)
xmap <leader>ca <Plug>(xmpfilter-clean)

" Switch definitions

" Switch ruby blocks: {...} <-> do...end, { |x| ... } <-> do |x| ... end
let b:switch_custom_definitions =
      \ [
      \   {
      \     '\_^\(\s*\)\(.\+\)\s\+do\s\+\(|.*|\)\n\s*\(.*\)\?\n\1end': '\1\2 { \3 \4 }',
      \     '\_^\(\s*\)\(.\+\)\s*{\s*\(|.*|\)\s*\<\(.*\)\>\s\+}': '\1\2do \3\1  \4\1end'
      \   },
      \   {
      \     '\_^\(\s*\)\(.\+\)\s\+do\n\s*\(.*\)\?\n\1end': '\1\2 { \3 }',
      \     '\_^\(\s*\)\(.\+\)\s*{\s*\(.*\)\s\+}': '\1\2do\1  \3\1end'
      \   },
      \ ]

" We want conceals to work in ruby.
setlocal conceallevel=2
