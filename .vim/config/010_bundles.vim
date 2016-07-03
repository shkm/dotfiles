if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

" -- Essentials
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'benekastah/neomake'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-dirvish'
Plug 'matchit.zip'
Plug 'gabesoft/vim-ags', { 'on': 'Ags' }
" Plug 'rking/ag.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'shougo/deoplete.nvim'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Neovim requires extra steps for vim-tmux-navigator.
" See https://github.com/christoomey/vim-tmux-navigator/issues/61#issuecomment-87284887
Plug 'christoomey/vim-tmux-navigator'

" -- Version control
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'
Plug 'int3/vim-extradite'

" -- Language / Framework support

" Ruby
Plug 'osyo-manga/vim-monster'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
Plug 'Keithbsmiley/rspec.vim', { 'for': 'ruby' }
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'ngmy/vim-rubocop', { 'for': 'ruby' }
Plug 'kana/vim-textobj-user' | Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }
" Plug 'vhakulinen/neovim-intellij-complete'
" Plug 'vhakulinen/neovim-intellij-complete-deoplete'

" Elixir
Plug 'elixir-lang/vim-elixir'
Plug 'awetzel/elixir.nvim', { 'do': 'yes \| ./install.sh' }

" PHP
Plug 'StanAngeloff/php.vim', { 'for': 'php' }

" Other languages
Plug 'mattn/emmet-vim'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'tpope/vim-haml', { 'for': 'haml' }
Plug 'indenthtml.vim', { 'for': 'html' }
Plug 'slim-template/vim-slim', { 'for': 'slim' }
Plug 'PProvost/vim-ps1', { 'for': 'powershell' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'irgeek/vim-puppet', { 'for': 'puppet' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'vim-scripts/yaml.vim', { 'for': 'yaml' }
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'freitass/todo.txt-vim', { 'for': 'todo' }
Plug 'zaiste/tmux.vim', { 'for': 'tmux' }
Plug 'tmux-plugins/vim-tmux'
Plug 'rhysd/vim-crystal'


" -- Color schemes
Plug 'mhartington/oceanic-next'
Plug 'noahfrederick/vim-noctu'
Plug 'whatyouhide/vim-gotham'
Plug 'eddsteel/vim-vimbrant'
Plug 'dracula/vim'

" -- Misc
Plug 'schickling/vim-bufonly', { 'on': 'Bonly' }
Plug 'AndrewRadev/switch.vim', { 'on': 'Switch' }
Plug 'godlygeek/tabular', { 'on': 'Tab' }
Plug 'benmills/vimux'
Plug 'Konfekt/FastFold'
Plug 'Keithbsmiley/investigate.vim'
Plug 'gorkunov/smartpairs.vim'
" Plug 'blueyed/vim-diminactive'
Plug 'calebsmith/vim-lambdify'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'thinca/vim-ref'
Plug 'dhruvasagar/vim-table-mode'

" Snippets.
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

call plug#end()
