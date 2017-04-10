function! RangerExplorer()
  exec "term ranger --choosefile=/tmp/vim_ranger_current_file " . expand("%:p:h")
  if filereadable('/tmp/vim_ranger_current_file')
    exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
    call system('rm /tmp/vim_ranger_current_file')
  endif
  redraw!
endfun

function! DirvishRename(new_name)
  execute '!mv ' . getline('.') . ' %'  . a:new_name
endfunction
