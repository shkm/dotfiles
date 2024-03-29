" -- Basics --
set termguicolors

" Indentation
set autoindent
set smartindent
set nostartofline
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Avoid mess
set backupdir=$HOME/.vim/backup//
set directory=$HOME/.vim/swap//
set undodir=$HOME/.vim/undo//

" Automatically reload file when it's changed externally
set autoread

" Case insensitive search
set hlsearch
set ignorecase
set smartcase

" Show results of commands incrementally
set inccommand=split

" Open new splits to right and bottom
set splitbelow
set splitright

" Whitespace characters
set listchars=tab:→\ ,nbsp:␣,trail:•,extends:»,precedes:«
set list

" Disable netrw; we need to do this earlier than plugin config.
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Time out from sequences immediately.
set timeoutlen=0

" -- Autocmds --

" Temporarily disable search highlighting when in insert mode.
autocmd InsertEnter * :setlocal nohlsearch
autocmd InsertLeave * :setlocal hlsearch

" Retain last edit position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
set viminfo^=%

" Transparent background
autocmd ColorScheme * hi Normal guibg='NONE'

" Spelling
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

" -- Mappings --

" Remap 0 to ^ (first char in line)
map 0 ^

" Switch ;/: for easier command entry.
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :

nnoremap <silent> - :edit %:p:h<CR>
nnoremap - :lua require'lir.float'.toggle()<cr>

" Window navigation
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Easier normal mode (ESC) in terminal
tnoremap <ESC> <C-\><C-n>

let mapleader = " "

nnoremap <Leader><TAB> <C-^>
nnoremap <Leader>/ <cmd>Telescope live_grep<CR>
vnoremap <Leader>/ <cmd>Telescope grep_string<CR>

" Sideways
nnoremap <s-h> :SidewaysLeft<cr>
nnoremap <s-l> :SidewaysRight<cr>

" ; Settings
nnoremap <Leader>;sb :set scrollbind<CR>

" b Buffers
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bj :bnext<CR>
nnoremap <Leader>bk :bprev<CR>
nnoremap <Leader>bf <cmd>Telescope buffers<CR>

" f Files/Find
nnoremap <Leader>f? <cmd>Telescope live_grep<CR>
nnoremap <Leader>ff <cmd>Telescope find_files<CR>
  " fe Find file in set place
  nnoremap <Leader>fed <cmd>Telescope find_files cwd=$HOME/dotfiles<CR>

" g Git
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gs :Git status<CR>

" s Specs
nnoremap <Leader>sf :TestFile<CR>
nnoremap <Leader>ss :TestNearest<CR>
nnoremap <Leader>sl :TestLast<CR>
nnoremap <Leader>sv :TestVisit<CR>
nnoremap <Leader>sa :TestSuite<CR>

" m Major: these should be filetype specific, so
" add them to ftplugin files.

" q Quickfix
nnoremap <Leader>qo :copen<CR>
nnoremap <Leader>qq :cclose<CR>

" -- Commands --

command! PrettyJson :%!python -m json.tool
command! PrettyHtml :%!tidy -q -i --show-errors 0 --raw
command! PrettyXml :%!tidy -q -i -xml --show-errors 0 --raw

" -- Plugin config (TODO move) -- 

" Trouble
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
