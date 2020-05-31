if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
  endif

function! s:on_lsp_buffer_enabled() abort
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gR <plug>(lsp-rename)
    ALEDisable
    echo "Loaded LSP."
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_signs_warning = {'text': ''}
let g:lsp_signs_error = {'text': ''}
let g:lsp_signs_hint = {'text': ''}
let g:lsp_signs_information = {'text': ''}

highlight link LspError DraculaError
highlight link LspErrorText DraculaError
highlight link LspErrorHighlight DraculaErrorLine

highlight link LspWarning DraculaWarnLine
highlight link LspWarningText DraculaWarnLine
highlight link LspWarningHighlight DraculaWarnLine

highlight link LspInformation DraculaComment
highlight link LspInformationText DraculaComment
highlight link LspInformationHighlight DraculaComment
