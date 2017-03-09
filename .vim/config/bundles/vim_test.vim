function! VagrantTransform(cmd) abort
  if !empty(glob("Vagrantfile"))
    return 'v '.shellescape(a:cmd)
  endif
endfunction

let g:test#custom_transformations = {'vagrant': function('VagrantTransform')}
let g:test#transformation = 'vagrant'
let test#ruby#cucumber#executable = 'xvfb-run cucumber'
let test#strategy = 'neovim'
