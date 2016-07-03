let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#auto_complete_start_length = 3
let g:deoplete#omni#input_patterns.ruby =
      \ ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
