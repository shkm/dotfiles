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
set statusline +=%<%m%r%h%w\ %f\%=                    " File
" set statusline +=%{fugitive#head()}\                  " Fugitive
set statusline +=%Y\                                  " FileType
set statusline +=%p\                                  " Position

" Hybrid colours
highlight StatusLine gui=NONE guifg=white guibg=#27292D
highlight StatusLineNC gui=NONE guifg=#27292D guibg=s:gui_background
