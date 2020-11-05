" Esc to exit
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

" command! -bang -nargs=? -complete=dir Files
"     \ call fzf#vim#files(<q-args>, {'options': ['--info=inline', '--preview', '']}, <bang>0)

" let g:fzf_layout = { 'window': {
"             \ 'width': 0.9,
"             \ 'height': 0.7,
"             \ 'border': 'sharp' } }
