if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'w0rp/ale'                                                                         " Build / linting
Plug 'tpope/vim-commentary'                                                             " Comments
Plug 'mhinz/vim-grepper'                                                                " Search for stuff
Plug 'justinmk/vim-dirvish'                                                             " Directory browser
Plug 'tpope/vim-rsi'                                                                    " More readline-style mappings
" Plug 'junegunn/vim-peekaboo'                                                            " Show registers

Plug 'wellle/targets.vim'                                                               " Various text objects
Plug 'tpope/vim-endwise'                                                                " Auto do...end
Plug 'tpope/vim-repeat'                                                                 " Better repeat
Plug 'tpope/vim-eunuch'                                                                 " Sugar for UNIX commands
Plug 'tpope/vim-unimpaired'                                                             " Various 'pair' mappings
Plug 'tpope/vim-abolish'                                                                " Improved search/replace
Plug 'junegunn/vim-slash'                                                               " Better slash search
Plug 'vim-scripts/matchit.zip'                                                          " Better pair matching (e.g. do...end)
Plug 'AndrewRadev/splitjoin.vim'                                                        " Split and join various statements
Plug 'AndrewRadev/switch.vim', { 'on': 'Switch' }                                       " Switch various statements
Plug 'janko-m/vim-test'                                                                 " Run tests for various languages
Plug 'kassio/neoterm'                                                                   " Run things in the neovim terminal

Plug 'Shougo/echodoc.vim'                                                               " Echo documentation

Plug 'roxma/nvim-completion-manager'                                                    " Completion
" Plug 'roxma/ncm-rct-complete'                                                           " Completion
Plug 'natebosch/vim-lsc'                                                                " Langauge server
Plug 'Shougo/neco-vim'                                                                  " Vim completion


Plug 'zenbro/mirror.vim'                                                                " Easily edit projects over ssh
Plug 'mhinz/neovim-remote'                                                              " Remote-control neovim
Plug 'jeetsukumaran/vim-indentwise'                                                     " Indent-level movement - [- / ]+ / ]=

Plug 'tpope/vim-fugitive'                                                               " Git
Plug 'lambdalisue/gina.vim'                                                             " Git manager
Plug 'junegunn/gv.vim'                                                                  " Git commit browser
Plug 'mhinz/vim-signify'                                                                " Show VCS changes in column
Plug 'int3/vim-extradite'                                                               " Browse git commits for the current file

Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }                                             " Ruby syntax
Plug 'Keithbsmiley/rspec.vim', { 'for': 'ruby' }                                        " RSpec syntax
Plug 'tpope/vim-rails'                                                                  " Rails-specific enhancements
Plug 'kana/vim-textobj-user' | Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' } " Ruby block textobj
Plug 'whatyouhide/vim-textobj-erb'
Plug 'tpope/vim-bundler'                                                                " Bundler enhancements

Plug 'elixir-lang/vim-elixir'                                                           " Elixir syntax
Plug 'slashmili/alchemist.vim'                                                          " Elixir enhancements

Plug 'StanAngeloff/php.vim', { 'for': 'php' }                                           " PHP syntax
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }                                   " Markdown enhancements
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }                               " Live markdown preview
Plug 'tpope/vim-haml', { 'for': 'haml' }                                                " HAML/Sass/Scss syntax
Plug 'vim-scripts/indenthtml.vim', { 'for': 'html' }                                    " Better HTML/CSS indentation
Plug 'kchmck/vim-coffee-script'                                                         " Coffeescript syntax
Plug 'chrisbra/csv.vim', { 'for': 'csv' }                                               " CSV enhancements
Plug 'irgeek/vim-puppet', { 'for': 'puppet' }                                           " Puppet syntax
Plug 'elzr/vim-json', { 'for': 'json' }                                                 " JSON syntax
Plug 'vim-scripts/yaml.vim', { 'for': 'yaml' }                                          " YAML syntax
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }                                    " YAML helper functions
Plug 'pangloss/vim-javascript'                                                          " Better JavaScript syntax
Plug 'zaiste/tmux.vim', { 'for': 'tmux' }                                               " Tmux syntax
Plug 'dag/vim-fish'                                                                     " Fish syntax
Plug 'vim-scripts/txt.vim'                                                              " General-purpose highlighting
Plug 'posva/vim-vue', { 'for': 'vue' }

" Colour scheme
" Plug 'tyrannicaltoucan/vim-quantum'
" Plug 'yuttie/hydrangea-vim'
Plug 'cocopon/iceberg.vim'

Plug 'junegunn/vim-easy-align'                                                          " Alignment
Plug 'Konfekt/FastFold'                                                                 " Faster folding
Plug 'Keithbsmiley/investigate.vim'                                                     " Documentation lookup
Plug 'dhruvasagar/vim-table-mode'                                                       " Table mode for constructing ascii tables
Plug 'metakirby5/codi.vim'                                                              " Repl
Plug 'powerman/vim-plugin-AnsiEsc'                                                      " colorize ANSI escape sequences

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

call plug#end()

let g:lsc_auto_map = v:true " Use defaults
