" Colors
" set t_Co=256
" set background=dark
colorscheme dracula

" Use a transparent background
hi Normal guibg=NONE

set nonumber

" Whitespace characters
set list listchars=tab:→\ ,nbsp:␣,trail:•,extends:»,precedes:«

" Vertical split separator should be full-height
" # TODO: is this slowing down vim?
set fillchars+=fold:-,vert:┃

" Modify tab label to present:
" 1 .vimrc +
set guitablabel=%N\ %t\ %M

" Status line section for language specific stuff
function! StatusLineModal()
  if &ft == 'yaml' || &ft == 'eruby.yaml'
    return execute('YamlDisplayFullPath')
  else
    return ''
  endif
endfunction
