setlocal shiftwidth=4 tabstop=4 softtabstop=4
set cindent
set cinoptions+=g0

if has('mac')
  let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
endif

" Compile / Run shortcuts
map <leader>co :w<CR>:!g++ -std=c++11 % -o %:r<CR>
map <leader>cr :w<CR>:!g++ -std=c++11 % -o %:r; ./%:r<CR>

" Commentary
set commentstring=//\ %s
