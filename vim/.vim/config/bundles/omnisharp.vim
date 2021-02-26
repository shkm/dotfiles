let g:OmniSharp_selector_ui = 'fzf'

" Format on save
autocmd BufWrite *.cs call OmniSharp#actions#format#Format()

autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
autocmd FileType cs nmap <silent> <buffer> K <Plug>(omnisharp_documentation)
autocmd FileType cs nmap <silent> <buffer> <Leader>k <Plug>(omnisharp_preview_definition)
autocmd FileType cs nmap <silent> <buffer> <Leader>fs <Plug>(omnisharp_find_symbol)
autocmd FileType cs nmap <silent> <buffer> <Leader>ft <Plug>(omnisharp_find_type)

" Navigate up and down by method/property/field
autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)

autocmd FileType cs nmap <silent> <buffer> <Leader>= <Plug>(omnisharp_code_format)

" Refactors
autocmd FileType cs nmap <silent> <buffer> <Leader>rl <Plug>(omnisharp_code_actions)
autocmd FileType cs nmap <silent> <buffer> <Leader>rR <Plug>(omnisharp_rename)

  let g:OmniSharp_fzf_options = { 'window': {
        \ 'width': 0.9,
        \ 'height': 0.7
        \ } }

  let g:OmniSharp_typeLookupInPreview = 1
  let g:OmniSharp_server_stdio = 1
  let g:OmniSharp_completion_without_overloads = 1
  let g:omnicomplete_fetch_full_documentation = 1
