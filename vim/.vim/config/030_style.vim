" Colors
" set t_Co=256
set background=dark
colorscheme one

" Make the current split more obvious
" augroup BgHighlight
"   autocmd! WinEnter * hi clear SignColor
"   autocmd! WinLeave * hi SignColor guibg=#333333 ctermbg=235
" augroup END

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
    set gfn=Iosevka:h18
  elseif IsWinGui()
    set gfn=Droid\ Sans\ Mono\ for\ Powerline:h11:cANSI
  else
    set gfn=Fira\ Mono\ 11
  endif
endif

" Status line section for language specific stuff
function! StatusLineModal()
  if &ft == 'yaml' || &ft == 'eruby.yaml'
    return execute('YamlDisplayFullPath')
  else
    return ''
  endif
endfunction

" Statusline
set laststatus=2
" set statusline=
" set statusline +=\ %n\                     " Buffer
" set statusline +=%<%m%r%h%w\ %f\           " File
" set statusline +=%{StatusLineModal()}      " Specific stuff
" set statusline +=%=                        " Right align
" " set statusline +=%{fugitive#statusline()}\ " Fugitive
" set statusline +=%{coc#status()}
" set statusline +=%Y\                       " FileType
" " set statusline +=%c×%l/%L\                 " Position
