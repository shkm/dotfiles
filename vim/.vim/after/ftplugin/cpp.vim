setlocal shiftwidth=4 tabstop=4 softtabstop=4
setlocal cindent
setlocal cinoptions+=g0

if has('mac')
  let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
endif

" Compile / Run shortcuts
map <buffer> <Leader>co :w<CR>:!g++ -std=c++11 % -o %:r<CR>
map <buffer> <Leader>cr :w<CR>:!g++ -std=c++11 % -o %:r; ./%:r<CR>

" Commentary
set commentstring=//\ %s
