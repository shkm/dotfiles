let mapleader = " "

nnoremap <Leader><TAB> <C-^>
nnoremap <Leader>/ :Grepper -tool rg<CR>
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
nnoremap <Leader>bf :Buffers<CR>

" f Files
nnoremap <Leader>f? :Ag<CR>
nnoremap <Leader>fA :A<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <leader>fd :Directories<CR>
  " fe Find file in set place
  nnoremap <Leader>fed :HFiles $HOME/dotfiles<CR>
  nnoremap <Leader>fev :Files $HOME/.vim/config<CR>
  nnoremap <Leader>fez :Files $HOME/.zsh<CR>
  nnoremap <Leader>fef :Files $HOME/.config/fish<CR>

" g Git
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gC :Commits<CR>
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

" t Tags
nnoremap <Leader>tf :Tags<CR>
nnoremap <Leader>tb :BTags<CR>

" m Major: these should be filetype specific, so
" add them to ftplugin files.
