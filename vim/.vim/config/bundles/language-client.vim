let g:LanguageClient_autoStop = 0
let g:LanguageClient_serverCommands = {
    \ 'ruby': ['tcp://localhost:7658']
    \ }
autocmd FileType ruby setlocal omnifunc=LanguageClient#complete
