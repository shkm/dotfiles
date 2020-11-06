" Don't match parameters. This was slowing vim down considerably.
let loaded_matchparen = 1

" We want conceals to work in ruby.
setlocal conceallevel=2

" Better indentation style
let g:ruby_indent_block_style = 'do'

function! RubocopAutocorrect()
  execute "!rubocop -a " . bufname("%")
endfunction

" Mappings
nnoremap <buffer> <Leader>mc :Econtroller<CR>
nnoremap <buffer> <Leader>mf :Efactory<CR>
nnoremap <buffer> <Leader>mm :Emodel<CR>
nnoremap <buffer> <Leader>mp :Epolicy<CR>
nnoremap <buffer> <Leader>ms :Eservice<CR>
nnoremap <buffer> <Leader>mt :Espec<CR>
nnoremap <buffer> <Leader>mv :Eview<CR>

  " mr Refactoring
  nnoremap <buffer> <Leader>mrs :Switch<CR>
  nnoremap <buffer> <Leader>mrr :call RubocopAutocorrect()<CR>

  " ml Lists
  nnoremap <buffer> <Leader>mlc :Files app/controllers/<CR>
  nnoremap <buffer> <Leader>mlf :Files spec/factories/<CR>
  nnoremap <buffer> <Leader>mlm :Files app/models/<CR>
  nnoremap <buffer> <Leader>mlp :Files app/policies/<CR>
  nnoremap <buffer> <Leader>mls :Files app/services/<CR>
  nnoremap <buffer> <Leader>mlt :Files spec/<CR>
  nnoremap <buffer> <Leader>mlv :Files app/views/<CR>

  " mo Open
  nnoremap <buffer> <Leader>mls :Eschema<CR>
  nnoremap <buffer> <Leader>mlr :Einitializer<CR>
