let mapleader = " "

nnoremap <leader><TAB> <C-^>
nnoremap <Leader>/ :Grepper -tool ag -grepprg ag -Q<CR>
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
  " fe Find file in set place
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

  " gh Hunks
  nnoremap <Leader>ghn :GitGutterNextHunk<CR>
  nnoremap <Leader>ghp :GitGutterPrevHunk<CR>
  nnoremap <Leader>ghP :GitGutterPreviewHunk<CR>
  nnoremap <Leader>ghr :GitGutterRevertHunk<CR>
  nnoremap <Leader>ghs :GitGutterStageHunk<CR>
  nnoremap <Leader>ghu :GitGutterUndoHunk<CR>

" s Specs
nnoremap <Leader>sf :TestFile<CR>
nnoremap <Leader>ss :TestNearest<CR>

" t Tags
nnoremap <Leader>tf :Tags<CR>
nnoremap <Leader>tb :BTags<CR>

" m Major TODO: rails specific right now; find a way to specify
nnoremap <Leader>mc :Econtroller<CR>
nnoremap <Leader>mf :Efactory<CR>
nnoremap <Leader>mm :Emodel<CR>
nnoremap <Leader>mp :Epolicy<CR>
nnoremap <Leader>ms :Eservice<CR>
nnoremap <Leader>mt :Espec<CR>
nnoremap <Leader>mv :Eview<CR>

  " mr Refactoring
  nnoremap <Leader>mrs :Switch<CR>

  " ml Lists
  nnoremap <Leader>mlc :Files app/controllers/<CR>
  nnoremap <Leader>mlf :Files spec/factories/<CR>
  nnoremap <Leader>mlm :Files app/models/<CR>
  nnoremap <Leader>mlp :Files app/policies/<CR>
  nnoremap <Leader>mls :Files app/services/<CR>
  nnoremap <Leader>mlt :Files spec/<CR>
  nnoremap <Leader>mlv :Files app/views/<CR>

  " mo Open
  nnoremap <Leader>mls :Eschema<CR>
  nnoremap <Leader>mlr :Einitializer<CR>
