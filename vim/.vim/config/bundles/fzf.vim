if isdirectory(expand("~/.fzf"))
  set rtp+=~/.fzf
elseif isdirectory("/usr/local/opt/fzf")
  set rtp+=/usr/local/opt/fzf
endif

let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!.git/*"'

" Ensure that esc closes fzf, even in a neovim terminal
autocmd FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

command! -complete=dir Directories call fzf#run({
      \'source': 'find . -type d -not -path "." -not -path ".git/*"',
      \'sink': 'e',
      \'down': '50%'
      \})


