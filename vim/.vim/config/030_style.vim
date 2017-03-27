" Colors
" set t_Co=256
colorscheme hybrid
set background=dark
set t_ut= " Disable BCE for BG colour in tmux

" Make the current split more obvious
" augroup BgHighlight
"   autocmd! WinEnter * hi clear SignColor
"   autocmd! WinLeave * hi SignColor guibg=#333333 ctermbg=235
" augroup END

" Relative line numbers
" Unfortunately this slows vim down to a crawl.
" Regular or no numbering does not.
" set relativenumber
set nonumber

" Whitespace characters
set list listchars=tab:→\ ,nbsp:␣,trail:•,extends:»,precedes:«

" Vertical split separator should be full-height
" # TODO: is this slowing down vim?
set fillchars+=fold:-,vert:│

" Modify tab label to present:
" 1 .vimrc +
set guitablabel=%N\ %t\ %M

if has('gui_running')
  " Font should be different depending on platform.
  if IsMacvim()
    set gfn=Fira\ Mono\ for\ Powerline:h14
  elseif IsWinGui()
    set gfn=Droid\ Sans\ Mono\ for\ Powerline:h11:cANSI
  else
    set gfn=Fira\ Mono\ 11
  endif
endif

" Statusline
set laststatus=2
set statusline=
set statusline +=\ %n\                                " Buffer
set statusline +=%<%m%r%h%w\ %f\                      " File
set statusline +=%=                                   " Right align
" set statusline +=%{fugitive#head()}\                " Fugitive
set statusline +=%Y\                                  " FileType
set statusline +=%p\                                  " Position

" Hybrid colours
highlight StatusLine gui=NONE guifg=white guibg=#27292D
highlight StatusLineNC gui=NONE guifg=#27292D guibg=s:gui_background

" Hybrid for neovim terminal
let g:terminal_color_0  = '#2d3c46'
let g:terminal_color_1  = '#a54242'
let g:terminal_color_2  = '#8c9440'
let g:terminal_color_3  = '#de935f'
let g:terminal_color_4  = '#5f819d'
let g:terminal_color_5  = '#85678f'
let g:terminal_color_6  = '#5e8d87'
let g:terminal_color_7  = '#6c7a80'
let g:terminal_color_8  = '#425059'
let g:terminal_color_9  = '#cc6666'
let g:terminal_color_10 = '#b5bd68'
let g:terminal_color_11 = '#f0c674'
let g:terminal_color_12 = '#81a2be'
let g:terminal_color_13 = '#b294bb'
let g:terminal_color_14 = '#8abeb7'
let g:terminal_color_15 = '#c5c8c6'

