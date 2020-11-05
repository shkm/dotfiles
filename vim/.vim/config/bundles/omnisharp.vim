let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_selector_ui = 'fzf'

autocmd CursorHold *.cs OmniSharpTypeLookup

autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
" autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
" autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
" autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
" autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
" autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
autocmd FileType cs nmap <silent> <buffer> K <Plug>(omnisharp_documentation)
" autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
" autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
" autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
" autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

" Navigate up and down by method/property/field
autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
" " Find all code errors/warnings for the current solution and populate the quickfix window
" autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
" " Contextual code actions (uses fzf, CtrlP or unite.vim selector when available)
" autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
" autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
" " Repeat the last code action performed (does not use a selector)
" autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
" autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

autocmd FileType cs nmap <silent> <buffer> <Leader> = <Plug>(omnisharp_code_format)

" autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)
