call plug#begin('~/.vim/plugged')

" " --------------------------------------------------
" " Basics
" " --------------------------------------------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'        " Fuzzy finder
Plug 'Konfekt/FastFold'        " Faster folding
Plug 'junegunn/vim-slash'      " Better slash search
Plug 'justinmk/vim-dirvish'    " Directory browser
Plug 'mhinz/vim-grepper'       " Project-wide search
Plug 'tpope/vim-commentary'    " Comments
Plug 'cohama/lexima.vim'       " Automatic pairs
Plug 'tpope/vim-eunuch'        " Sugar for UNIX commands
Plug 'tpope/vim-repeat'        " Better repeat
Plug 'tpope/vim-rsi'           " Readline mappings
Plug 'tpope/vim-unimpaired'    " Various 'pair' mappings
Plug 'vim-scripts/matchit.zip' " Better pair matching (e.g. do...end)
Plug 'w0rp/ale'                " Linter

" --------------------------------------------------
" Refactoring
" --------------------------------------------------
Plug 'AndrewRadev/sideways.vim'  " Move stuff sideways
Plug 'AndrewRadev/splitjoin.vim' " Split and join various statements
Plug 'AndrewRadev/switch.vim'    " Switch various statements
Plug 'tpope/vim-abolish'         " Improved search/replace

" --------------------------------------------------
" Text objects
" --------------------------------------------------
Plug 'tpope/vim-surround' " Surround text object
Plug 'wellle/targets.vim' " Various text objects

" --------------------------------------------------
" VCS
" --------------------------------------------------
Plug 'int3/vim-extradite'   " Browse git commits for the current file
Plug 'junegunn/gv.vim'      " Git commit browser
Plug 'lambdalisue/gina.vim' " Git manager
Plug 'mhinz/vim-signify'    " Show VCS changes in column
Plug 'tpope/vim-fugitive'   " Git

" --------------------------------------------------
" Ruby
" --------------------------------------------------
Plug 'Keithbsmiley/rspec.vim'          " RSpec syntax
Plug 'kana/vim-textobj-user'           " Dependency
Plug 'nelstrom/vim-textobj-rubyblock'  " Ruby block textobj
Plug 'ngmy/vim-rubocop'                " Rubocop linter with additional functionality
Plug 'tpope/vim-bundler'               " Bundler enhancements
Plug 'tpope/vim-rails'                 " Rails-specific enhancements
Plug 'vim-ruby/vim-ruby',              " Ruby syntax
Plug 'whatyouhide/vim-textobj-erb'     " ERB textobj

" --------------------------------------------------
" Terminal
" --------------------------------------------------
if has('nvim')
  Plug 'kassio/neoterm' " Run things in the neovim terminal
endif

" --------------------------------------------------
" Testing
" --------------------------------------------------
Plug 'janko-m/vim-test' " Run tests for various languages

" --------------------------------------------------
" Documentation
" --------------------------------------------------
" Plug 'Keithbsmiley/investigate.vim'  " Documentation lookup
" Plug 'Shougo/echodoc.vim'            " Echo documentation
" Plug 'Shougo/neco-vim'               " Vim completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'shkm/LanguageClient-neovim', {
			  \ 'branch': 'next',
			  \ 'do': 'bash install.sh',
			  \ }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'Shougo/neosnippet.vim' " Snippets
Plug 'Shougo/neosnippet-snippets'    " Actual snippets for use with neosnippet

" --------------------------------------------------
" Tools
" --------------------------------------------------
Plug 'chrisbra/Colorizer'      " Colorize hex colours
Plug 'junegunn/vim-easy-align' " Alignment
Plug 'zenbro/mirror.vim'       " Easily edit projects over ssh
if has('nvim')
  Plug 'mhinz/neovim-remote'     " Remote-control neovim
endif

" --------------------------------------------------
" Elixir
" --------------------------------------------------
Plug 'elixir-lang/vim-elixir'  " Elixir syntax
Plug 'slashmili/alchemist.vim' " Elixir enhancements

" --------------------------------------------------
" PHP
" --------------------------------------------------
Plug 'StanAngeloff/php.vim', { 'for': 'php' } " PHP syntax

" --------------------------------------------------
" Markdown
" --------------------------------------------------
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' } " Live markdown preview
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }     " Markdown enhancements

" --------------------------------------------------
" HTML
" --------------------------------------------------
Plug 'vim-scripts/indenthtml.vim', { 'for': 'html' } " Better HTML/CSS indentation
Plug 'mattn/emmet-vim'                               " HTMl expansion

" --------------------------------------------------
" Coffeescript
" --------------------------------------------------
Plug 'kchmck/vim-coffee-script' " Coffeescript syntax

" --------------------------------------------------
" JavaScript
" --------------------------------------------------
Plug 'mxw/vim-jsx'              " JSX support
Plug 'pangloss/vim-javascript'  " Better JavaScript syntax
Plug 'carlitux/deoplete-ternjs' " Deoplete source

" --------------------------------------------------
" Misc language support
" --------------------------------------------------
Plug 'chrisbra/csv.vim', { 'for': 'csv' }            " CSV enhancements
Plug 'elzr/vim-json', { 'for': 'json' }              " JSON syntax
Plug 'irgeek/vim-puppet', { 'for': 'puppet' }        " Puppet syntax
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' } " YAML helper functions
Plug 'posva/vim-vue', { 'for': 'vue' }               " Vue
Plug 'tpope/vim-haml', { 'for': 'haml' }             " HAML/Sass/Scss syntax
Plug 'vim-scripts/txt.vim'                           " General-purpose highlighting
Plug 'vim-scripts/yaml.vim', { 'for': 'yaml' }       " YAML syntax
Plug 'zaiste/tmux.vim', { 'for': 'tmux' }            " Tmux syntax

" --------------------------------------------------
" Styles
" --------------------------------------------------
Plug 'arcticicestudio/nord-vim'

" --------------------------------------------------
" Misc
" --------------------------------------------------
Plug 'dhruvasagar/vim-table-mode'   " Table mode for constructing ascii tables
Plug 'metakirby5/codi.vim'          " Repl
Plug 'powerman/vim-plugin-AnsiEsc'  " colorize ANSI escape sequences
Plug 'kshenoy/vim-signature'        " show marks

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }   " Completion

call plug#end()
