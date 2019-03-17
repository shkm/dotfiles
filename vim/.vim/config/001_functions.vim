function! DirvishRename(new_name)
  execute '!mv "' . getline('.') . '" %' . a:new_name
endfunction

function! DirvishTrash()
  execute '!trash "' . getline('.') . '"'
endfunction

function! Trash()
  execute '!trash "' . expand('%p') . '"'
endfunction

function! DirvishQuickLook()
  execute '!qlmanage "' . getline('.') . '" -p > /dev/null 2>&1'
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

function! ClearMultipleReturns()
  g/^\_$\n\_^$/d
endfunction

function! StripColours()
  %!sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"
endfunction
