fun! BufWritePreStrip()
  " Don't run on large files
  let lines = str2nr(line('$'))
  if (lines > 1000)
    return
  endif

  " Don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif

  silent! call Strip()
endfun

fun! BufWritePreClearMultipleReturns()
  " Don't run on large files
  let lines = str2nr(line('$'))
  if (lines > 1000)
    return
  endif
  silent! call ClearMultipleReturns()
endfun

autocmd! BufWritePre * call BufWritePreStrip()
autocmd! BufWritePre * call BufWritePreClearMultipleReturns()
