if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" --------------------------------------------------
" Basics
" --------------------------------------------------
Plug 'junegunn/fzf.vim'        " Fuzzy finding
Plug 'Konfekt/FastFold'        " Faster folding
Plug 'justinmk/vim-dirvish'    " Directory browser
Plug 'mhinz/vim-grepper'       " Project-wide search
Plug 'tpope/vim-commentary'    " Comments
" Plug 'cohama/lexima.vim'       " Automatic pairs
Plug 'tpope/vim-eunuch'        " Sugar for UNIX commands
Plug 'tpope/vim-repeat'        " Better repeat
Plug 'tpope/vim-rsi'           " Readline mappings
Plug 'tpope/vim-unimpaired'    " Various 'pair' mappings
Plug 'vim-scripts/matchit.zip' " Better pair matching (e.g. do...end)
" Plug 'romainl/vim-cool'        " :nohl when searching is done
Plug 'itchyny/lightline.vim'
Plug 'ciaranm/securemodelines'

" --------------------------------------------------
" Refactoring
" --------------------------------------------------
Plug 'AndrewRadev/sideways.vim'  " Move stuff sideways
Plug 'AndrewRadev/splitjoin.vim' " Split and join various statements
Plug 'AndrewRadev/switch.vim'    " Switch various statements
" Plug 'tpope/vim-abolish'         " Improved search/replace

" --------------------------------------------------
" Text objects
" --------------------------------------------------
Plug 'tpope/vim-surround' " Surround text object
Plug 'wellle/targets.vim' " Various text objects

" --------------------------------------------------
" VCS
" --------------------------------------------------
" Plug 'mhinz/vim-signify'    " Show VCS changes in column
Plug 'tpope/vim-fugitive'   " Git

" --------------------------------------------------
" Ruby
" --------------------------------------------------
Plug 'Keithbsmiley/rspec.vim'          " RSpec syntax
" Plug 'kana/vim-textobj-user'           " Dependency
" Plug 'nelstrom/vim-textobj-rubyblock'  " Ruby block textobj
Plug 'tpope/vim-rails'                 " Rails-specific enhancements
Plug 'vim-ruby/vim-ruby',              " Ruby syntax
" Plug 'whatyouhide/vim-textobj-erb'     " ERB textobj

" --------------------------------------------------
" Go
" --------------------------------------------------
" Plug 'fatih/vim-go'

" --------------------------------------------------
" Testing
" --------------------------------------------------
Plug 'janko-m/vim-test' " Run tests for various languages

" --------------------------------------------------
" Documentation
" --------------------------------------------------
" Plug 'Shougo/neco-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
" Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
" Plug 'prabirshrestha/asyncomplete-necovim.vim'
Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'sunaku/vim-dasht'
Plug 'dense-analysis/ale'

" --------------------------------------------------
" Tools
" --------------------------------------------------
Plug 'junegunn/vim-easy-align' " Alignment
Plug 'chrisbra/Colorizer'        " Hex colors
Plug 'zenbro/mirror.vim'       " Easily edit projects over ssh

" --------------------------------------------------
" PHP
" --------------------------------------------------
" Plug 'StanAngeloff/php.vim', { 'for': 'php' } " PHP syntax

" --------------------------------------------------
" Markdown
" --------------------------------------------------
Plug 'plasticboy/vim-markdown'    " Markdown enhancements

" --------------------------------------------------
" HTML
" --------------------------------------------------
Plug 'vim-scripts/indenthtml.vim', { 'for': 'html' } " Better HTML/CSS indentation
Plug 'mattn/emmet-vim'                               " HTMl expansion
" Plug 'AndrewRadev/tagalong.vim'                      " Easier changing tags

" --------------------------------------------------
" Coffeescript
" --------------------------------------------------
Plug 'kchmck/vim-coffee-script' " Coffeescript syntax

" --------------------------------------------------
" JavaScript
" --------------------------------------------------
" Plug 'mxw/vim-jsx'              " JSX support
Plug 'pangloss/vim-javascript'  " Better JavaScript syntax

" --------------------------------------------------
" TypeScript
" --------------------------------------------------
" Plug 'leafgarland/typescript-vim' " Syntax

" --------------------------------------------------
" Misc language support
" --------------------------------------------------
" Plug 'chrisbra/csv.vim', { 'for': 'csv' }            " CSV enhancements
Plug 'elzr/vim-json', { 'for': 'json' }              " JSON syntax
" Plug 'mogelbrod/vim-jsonpath', { 'for': 'json' }     " JSON path information
" Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' } " YAML helper functions
Plug 'tpope/vim-haml', { 'for': 'haml' }             " HAML/Sass/Scss syntax
Plug 'vim-scripts/txt.vim'                           " General-purpose highlighting
Plug 'vim-scripts/yaml.vim', { 'for': 'yaml' }       " YAML syntax

" --------------------------------------------------
" Styles
" --------------------------------------------------
Plug 'bluz71/vim-nightfly-guicolors'

" --------------------------------------------------
" C-Sharp
" --------------------------------------------------
Plug 'OmniSharp/omnisharp-vim'

" --------------------------------------------------
" Misc
" --------------------------------------------------
" Plug 'dhruvasagar/vim-table-mode'   " Table mode for constructing ascii tables
" Plug 'powerman/vim-plugin-AnsiEsc'  " colorize ANSI escape sequences

"Zettelkasten
" Plug 'fiatjaf/neuron.vim'

call plug#end()
