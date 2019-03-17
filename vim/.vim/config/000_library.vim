" Return true if editor is Macvim
function! IsMacvim()
  return has('gui_running') && has('gui_macvim')
endfunction

" Return true if editor is a GUI editor under Windows
function! IsWinGui()
  return has('gui_running') && has('gui_win32')
endfunction

" Return true if editor is a GUI editor under GTK
function! IsGtkGui()
  return has('gui_running') && has('gui_win32')
endfunction

" Load a single settings file from ~/.vim/settings/
" Automatically appends a .vim extension.
function! LoadSettingsFile(file)
  exe 'source $HOME/.vim/settings/' . a:file . '.vim'
endfunction

" Loads an array of files with LoadSettingsFile()
function! LoadSettings(files)
  for f in a:files
    call LoadSettingsFile(f)
  endfor
endfunction

" Sources all files in a directory
" Optionally only sources files with the given extension
function! SourceDir(dir, ...)
  let extension = (a:0 > 0)? '.' . a:1 : ''

  for f in split(globpath(a:dir,  '*' . extension), '\n')
    " Check if it's a readable file (and not a dir)
    if filereadable(f)
      exe 'source' f
    endif
  endfor
endfunction
