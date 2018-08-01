function! TestVsplitStrategy(cmd)
  VtrOpenRunner { 'orientation': 'h', 'percentage': 25 }
  call VtrSendCommand(a:cmd)
endfunction

let g:test#custom_strategies = {'vsplit': function('TestVsplitStrategy')}
let g:test#strategy = 'vsplit'
let test#ruby#use_binstubs = 0
