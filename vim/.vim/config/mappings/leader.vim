let mapleader = " "

nnoremap <Leader><TAB> <C-^>
nnoremap <Leader>/ :Grepper<CR>
nnoremap <Leader>? :Ag<CR>

" ; Settings
nnoremap <Leader>;sb :set scrollbind<CR>

" b Buffers
nnoremap <Leader>b/ :BLines<CR>
nnoremap <Leader>b<C-I> :e #<CR>
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bj :bnext<CR>
nnoremap <Leader>bk :bprev<CR>
nnoremap <Leader>bO :Bonly<CR>
nnoremap <Leader>bf :PickerBuffer<CR>

" y Yank
nnoremap <Leader>yP :let @+=expand("%:p")<CR>

" f Files
nnoremap <Leader>f? :Ag<CR>
nnoremap <Leader>fA :A<CR>
nnoremap <Leader>ff :PickerEdit<CR>
nnoremap <Leader>fd :call picker#File('fd -t d', 'e')<CR>
  " fe Find file in set place
  nnoremap <Leader>fed :call picker#File('fd . $HOME/dotfiles -H', 'e')<CR>
  nnoremap <Leader>fev :call picker#File('fd . --extension .vim $HOME/.vim', 'e')<CR>
  nnoremap <Leader>fez :call picker#File('fd . $HOME/.zsh', 'e')<CR>
  nnoremap <Leader>fes :call picker#File('fd . $HOME/.vim/snippets', 'e')<CR>
  " fo Open file in set place
  nnoremap <leader>fos :e /tmp/scratch<CR>

" g Git
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit<CR>
" nnoremap <Leader>gC :Commits<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap <Leader>ge :Extradite<CR>
nnoremap <Leader>gl :Gitv<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gS :Magit<CR>

" s Specs
nnoremap <Leader>sf :TestFile<CR>
nnoremap <Leader>ss :TestNearest<CR>
nnoremap <Leader>sl :TestLast<CR>
nnoremap <Leader>sv :TestVisit<CR>
nnoremap <Leader>sa :TestSuite<CR>

" t Tags
nnoremap <Leader>tf :PickerTag<CR>
nnoremap <Leader>tb :PickerBufferTag<CR>

" l Lint
nnoremap <Leader>ld :ALEDetail<CR>

" m Major: these should be filetype specific, so
" add them to ftplugin files.
