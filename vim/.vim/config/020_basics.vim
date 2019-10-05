" Don't show current mode at bottom
set noshowmode

" Hide abandoned buffers
" set hidden

" Set shell
set shell=zsh

" Syntax highlighting
syntax on

" Use GB English, NL
set spelllang=en_gb,nl

" Better command-line completion
set wildmenu

" Ignore various file types
set wildignore+=*.scssc,.DS_Store

" Show autocompletion even if there's only one item
" set completeopt=menu,menuone,preview,longest

" Disable timeout on mappings. Very useful for leader stuff.
set notimeout

" A little optimization
set scrolljump=5

" Speed up rendering
set lazyredraw

" Avoid backup mess (.doc.swp, ~.doc) by moving backups tmp
set backupcopy=yes
set backupdir=$HOME/.tmp
set directory=$HOME~/.tmp

" Don't warn when there's an existing swap file.
set shortmess+=A

" Automatically reload file when it's changed externally
set autoread

" Indentation
set autoindent
set smartindent
set nostartofline
set shiftwidth=2
set softtabstop=2
set expandtab

" Max columns
set colorcolumn=120

" Don't insert line breaks after 80 columns. PLEASE.
set textwidth=0

" Backspace over autoindent, line breaks, etc.
set backspace=indent,eol,start

" Always use unix as default file format
set ffs=unix,dos,mac

" Disable comments carrying over to new lines
autocmd FileType * setlocal formatoptions-=cro

" Search highlighting, case insensitivity
set hlsearch
set ignorecase
set smartcase

" incsearch is slow.
" set noincsearch

" Temporarily disable search highlighting when in insert mode.
autocmd InsertEnter * :setlocal nohlsearch
autocmd InsertLeave * :setlocal hlsearch

" Enable mouse for other users
set mouse=a

" Open new splits to right and bottom
set splitbelow
set splitright

" Retain last edit position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
set viminfo^=%

" Search various tags files in proper order
set tags=./tags,tags,gemtags
