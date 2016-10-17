" ------------------------------------------------------------------------------
" Leader mappings have been replaced to use vim-leader-guide.
" This gives us a more Emacs guide-key approach to leader commands, which I
" find more useful.
" ------------------------------------------------------------------------------

let mapleader = "\<Space>"

let g:all_key_map = {}
let g:leader_key_map = {
      \'name' : '<Space>',
      \'<C-I>' : [':e #', 'Last buffer'],
      \'/' : [':Ag', 'Search in files'],
      \}

let g:leader_key_map[';'] = {
      \'name' : 'Settings',
      \'sb' : [':set scrollbind', 'scrollbind'],
      \}

let g:leader_key_map['b'] = {
      \'name' : 'Buffer',
      \'/' : [':BLines', 'Search in buffer'],
      \'<C-I>' : [':e #', 'Last buffer'],
      \'d' : [':bdelete', 'Delete buffer'],
      \'j' : [':bnext', 'Next'],
      \'k' : [':bprev', 'Previous buffer'],
      \'O' : [':Bonly', 'Kill all other buffers'],
      \'f' : [':Buffers', 'Find buffer'],
      \}

let g:leader_key_map['f'] = {
      \'name' : 'File',
      \'/' : [':Ag', 'Search in files'],
      \'A' : [':A', 'Alternate file'],
      \'f' : [':Files', 'Find file'],
      \}
let g:leader_key_map['f']['e'] = {
      \'name' : 'Edit/list file(s)',
      \'v' : [':Files $HOME/.vim/config', 'Vim'],
      \'z' : [':Files $HOME/.zsh', 'Zsh'],
      \}

let g:leader_key_map['g'] = {
      \'name' : 'Git',
      \'b' : [':Gblame', 'Blame'],
      \'c' : [':Gcommit', 'Commit'],
      \'C' : [':Commits', 'List commits'],
      \'d' : [':Gvdiff', 'Diff'],
      \'e' : [':Extradite', 'Extradite'],
      \'l' : [':Gitv', 'Log'],
      \'s' : [':Gstatus', 'Status'],
      \'S' : [':Magit', 'Magit'],
      \}

" Hopefully figure out how to bind this specifically
" later on. For now, I mostly work with rails so this is ok.
let g:leader_key_map['m'] = {
      \'name' : 'Main',
      \'c' : [':Econtroller', 'Controller'],
      \'f' : [':Efactory', 'Factory'],
      \'m' : [':Emodel', 'Model'],
      \'p' : [':Epolicy', 'Policy'],
      \'s' : [':Eservice', 'Service'],
      \'t' : [':Espec', 'Spec'],
      \'v' : [':Eview', 'View'],
      \}
let g:leader_key_map['m']['l'] = {
      \'name' : 'List',
      \'c' : [':Files app/controllers/', 'Controllers'],
      \'f' : [':Files spec/factories/', 'Factories'],
      \'m' : [':Files app/models/', 'Models'],
      \'p' : [':Files app/policies/', 'Policies'],
      \'s' : [':Files app/services/', 'Services'],
      \'t' : [':Files spec/', 'Specs'],
      \'v' : [':Files app/views/', 'Views'],
      \}
let g:leader_key_map['m']['o'] = {
      \'name' : 'Open',
      \'s' : [':Eschema', 'Schema'],
      \'r' : [':Einitializer', 'Routes'],
      \}

let g:leader_key_map['t'] = {
      \'name' : 'Tags',
      \'f': [':Tags', 'Find tag'],
      \'b': [':BTags', 'Buffer tags']
      \}

let g:all_key_map['<Space>'] = g:leader_key_map
let mapleader = ""
call leaderGuide#register_prefix_descriptions("<Space>", "g:leader_key_map")
nnoremap <silent> <Space> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <Space> :<c-u>LeaderGuideVisual '<Space>'<CR>
