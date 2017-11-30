function! RangerExplorer()
  exec "term ranger --choosefile=/tmp/vim_ranger_current_file " . expand("%:p:h")
  if filereadable('/tmp/vim_ranger_current_file')
    exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
    call system('rm /tmp/vim_ranger_current_file')
  endif
  redraw!
endfunction

function! DirvishRename(new_name)
  execute '!mv ' . getline('.') . ' %'  . a:new_name
endfunction

function! ProfileStart()
  profile start /tmp/vim_profile.log
  profile func *
  profile file *
endfunction

function! ProfileStop()
  profile pause
  noautocmd qall!
endfunction

function! TmuxPane(direction)
  let wnr = winnr()
  silent! execute 'wincmd ' . a:direction

  " If the winnr is still the same after we moved, it is the last pane
  if wnr == winnr()
    call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
  end
endfunction

function! Strip()
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction

function! StripColours()
  %!sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"
endfunction
