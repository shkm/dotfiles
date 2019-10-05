autocmd BufNewFile,BufRead *_spec.rb set ft=ruby.rspec
autocmd BufNewFile,BufRead *.mmd set ft=markdown
autocmd BufNewFile,BufRead *.tsx set ft=typescript.tsx
autocmd BufNewFile,BufRead *.snippets set ft=snippets
autocmd BufNewFile,BufRead *.sh set ft=sh

" Better HTML indentation
let g:html_indent_inctags = "html,body,head,p,tbody"

" Omnicompletion
" autocmd FileType scss,css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" autocmd FileType ruby setlocal completefunc=LanguageClient#complete
