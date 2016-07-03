" ------------------------------------------------------------------------------
" Leader mappings should mostly follow these conventions:
"
"   f*     Find
"   b*     Buffers
"   o*     Open files
"   t*     Tags
"   g*     Git
"   s*     Specs
"   r*     Rails
"   l*     Lists
"   ;*     Setting
"   **     Special
" ------------------------------------------------------------------------------

let mapleader = "\<Space>"

" -- f*  Find
nnoremap <silent> <Leader>ff :BLines<CR>
nnoremap <leader>fa :Ag 
nnoremap <leader>fi :Ags 


" -- b*  Buffers
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bk :bprev<CR>
nnoremap <leader>bj :bnext<CR>
nnoremap <leader>bo :Bonly<cr>
nnoremap <leader><Tab> <C-^>

" -- o*  Open files
nnoremap <leader>orc :e ~/.vimrc<CR>

" -- t*  Tags
nnoremap <silent> <leader>ta :Tags<CR>
nnoremap <silent> <leader>tt :BTags<CR>

" -- g*  Git
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gC :Commits<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>ge :Extradite<CR>

" -- s*  Specs
nnoremap <leader>sf :call RunCurrentSpecFile()<CR>
nnoremap <leader>ss :call RunNearestSpec()<CR>
nnoremap <leader>sl :call RunLastSpec()<CR>
nnoremap <leader>sa :call RunAllSpecs()<CR>

" -- r*  Rails
nnoremap <leader>rm :Emodel
nnoremap <leader>rv :Eview
nnoremap <leader>rc :Econtroller
nnoremap <leader>rs :Eservice
nnoremap <leader>rp :Epolicy
nnoremap <leader>rt :Espec
nnoremap <leader>rf :Efactory

" -- l*  Lists

" --- lv   List vim
nnoremap <leader>lv :Files $HOME/.vim/config<CR>
" --- lz   List zsh
nnoremap <leader>lz :Files $HOME/.zsh<CR>

" --- lr*  List rails
nnoremap <leader>lrm :Files "app/models/"<CR>
nnoremap <leader>lrv :Files "app/views/"<CR>
nnoremap <leader>lrc :Files "app/controllers/"<CR>
nnoremap <leader>lrs :Files "spec/"<CR>
nnoremap <leader>lrp :Files "app/policies/"<CR>
nnoremap <leader>lrf :Files "spec/factories/"<CR>

" --- lf List all files
nnoremap <leader>lf :FZF

" -- ;*  Settings
nnoremap <leader>;sb :set scrollbind<CR>

" -- **   Special
" --- w     save
nnoremap <leader>w :w<CR>

" --- /     comment
map <leader>/ gcc

" --- `     nerdtree
nnoremap <leader>` :NERDTreeToggle<CR>

" --- ~     ranger
nnoremap <leader>~ :call RangerExplorer()<CR>

" --- y/p   copy/paste system clipboard
nnoremap <leader>yy "+y
nnoremap <leader>pp "+p
nnoremap <leader>pP "+P
