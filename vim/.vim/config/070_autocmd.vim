fun! BufWritePreStrip()
  " Don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif

  call Strip()
endfun

autocmd BufWritePre * call BufWritePreStrip()
