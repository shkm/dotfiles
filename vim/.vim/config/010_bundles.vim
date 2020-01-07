call plug#begin('~/.vim/plugged')

" " --------------------------------------------------
" " Basics
" " --------------------------------------------------
Plug 'srstevenson/vim-picker'  " Fuzzy finding
Plug 'Konfekt/FastFold'        " Faster folding
Plug 'justinmk/vim-dirvish'    " Directory browser
Plug 'mhinz/vim-grepper'       " Project-wide search
Plug 'tpope/vim-commentary'    " Comments
Plug 'cohama/lexima.vim'       " Automatic pairs
Plug 'tpope/vim-eunuch'        " Sugar for UNIX commands
Plug 'tpope/vim-repeat'        " Better repeat
Plug 'tpope/vim-rsi'           " Readline mappings
Plug 'tpope/vim-unimpaired'    " Various 'pair' mappings
Plug 'vim-scripts/matchit.zip' " Better pair matching (e.g. do...end)
Plug 'romainl/vim-cool'        " :nohl when searching is done
Plug 'itchyny/lightline.vim'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'ciaranm/securemodelines'

" --------------------------------------------------
" Refactoring
" --------------------------------------------------
Plug 'AndrewRadev/sideways.vim'  " Move stuff sideways
Plug 'AndrewRadev/splitjoin.vim' " Split and join various statements
Plug 'AndrewRadev/switch.vim'    " Switch various statements
Plug 'AndrewRadev/writable_search.vim' " Write-able search buffer
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
" Go
" --------------------------------------------------
Plug 'fatih/vim-go'

" --------------------------------------------------
" Terminal
" --------------------------------------------------
if has('nvim')
  " Plug 'kassio/neoterm' " Run things in the neovim terminal
endif

" --------------------------------------------------
" Testing
" --------------------------------------------------
Plug 'janko-m/vim-test' " Run tests for various languages

" --------------------------------------------------
" Documentation
" --------------------------------------------------
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
Plug 'honza/vim-snippets'

" --------------------------------------------------
" Tools
" --------------------------------------------------
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  } " Live markdown preview
Plug 'plasticboy/vim-markdown'    " Markdown enhancements

" --------------------------------------------------
" HTML
" --------------------------------------------------
Plug 'vim-scripts/indenthtml.vim', { 'for': 'html' } " Better HTML/CSS indentation
Plug 'mattn/emmet-vim'                               " HTMl expansion
Plug 'AndrewRadev/tagalong.vim'                      " Easier changing tags

" --------------------------------------------------
" Coffeescript
" --------------------------------------------------
Plug 'kchmck/vim-coffee-script' " Coffeescript syntax

" --------------------------------------------------
" JavaScript
" --------------------------------------------------
Plug 'mxw/vim-jsx'              " JSX support
Plug 'pangloss/vim-javascript'  " Better JavaScript syntax

" --------------------------------------------------
" TypeScript
" --------------------------------------------------
Plug 'leafgarland/typescript-vim' " Syntax
" --------------------------------------------------
" Misc language support
" --------------------------------------------------
Plug 'chrisbra/csv.vim', { 'for': 'csv' }            " CSV enhancements
Plug 'elzr/vim-json', { 'for': 'json' }              " JSON syntax
Plug 'mogelbrod/vim-jsonpath', { 'for': 'json' }     " JSON path information
Plug 'irgeek/vim-puppet', { 'for': 'puppet' }        " Puppet syntax
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' } " YAML helper functions
Plug 'posva/vim-vue', { 'for': 'vue' }               " Vue
Plug 'tpope/vim-haml', { 'for': 'haml' }             " HAML/Sass/Scss syntax
Plug 'slim-template/vim-slim', { 'for': 'slim' }     " Slim syntax
Plug 'vim-scripts/txt.vim'                           " General-purpose highlighting
Plug 'vim-scripts/yaml.vim', { 'for': 'yaml' }       " YAML syntax
Plug 'zaiste/tmux.vim', { 'for': 'tmux' }            " Tmux syntax

" --------------------------------------------------
" Styles
" --------------------------------------------------
" Plug 'haishanh/night-owl.vim'
Plug 'rakr/vim-one'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'ayu-theme/ayu-vim'
Plug 'Rigellute/rigel'

" --------------------------------------------------
" Misc
" --------------------------------------------------
Plug 'dhruvasagar/vim-table-mode'   " Table mode for constructing ascii tables
Plug 'metakirby5/codi.vim'          " Repl
Plug 'powerman/vim-plugin-AnsiEsc'  " colorize ANSI escape sequences
Plug 'kshenoy/vim-signature'        " show marks
Plug 'christoomey/vim-tmux-runner'  " run commands in tmux
call plug#end()
