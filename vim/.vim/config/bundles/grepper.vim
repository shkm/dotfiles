let g:grepper = {}
let g:grepper = {
      \ 'tools': ['rgexact', 'rg', 'ag', 'grep', 'git'],
      \ 'rgexact': { 'grepprg': 'rg -H --no-heading --ignore-file $HOME/.gitignore_global --vimgrep -F'  }
      \ }
