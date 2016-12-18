" ------------------------------------------------------------------------------
" Leader mappings have been replaced to use vim-leader-guide.
" This gives us a more Emacs guide-key approach to leader commands, which I
" find more useful.
" ------------------------------------------------------------------------------

let mapleader = "\<Space>"

let g:leader_key_dict = {
      \'name':  '<Space>',
      \'<C-I>': [':e #', 'Last buffer'],
      \'/':     [':Grepper -tool ag', 'Find in files'],
      \'?':     [':Ag', 'Find in files incrementally'],
      \}

" Settings
let g:leader_key_dict[';'] = {
      \'name':  'Setting',
      \'sb':    [':set scrollbind', 'scrollbind'],
      \}

" Buffers
let g:leader_key_dict['b'] = {
      \'name':  'Buffer',
      \'/':     [':BLines', 'Search in buffer'],
      \'<C-I>': [':e #', 'Last buffer'],
      \'d':     [':bdelete', 'Delete buffer'],
      \'j':     [':bnext', 'Next'],
      \'k':     [':bprev', 'Previous buffer'],
      \'O':     [':Bonly', 'Kill all other buffers'],
      \'f':     [':Buffers', 'Find buffer'],
      \}

" Files
let g:leader_key_dict['f'] = {
      \'name':  'File',
      \'/':     [':Grepper --tool ag', 'Find in files'],
      \'?':     [':Ag', 'Find in files incrementally'],
      \'A':     [':A', 'Alternate file'],
      \'f':     [':Files', 'Find file'],
      \}

  let g:leader_key_dict['f']['e'] = {
        \'name':  'Edit/list file(s)',
        \'v':     [':Files $HOME/.vim/config', 'Vim'],
        \'z':     [':Files $HOME/.zsh', 'Zsh'],
        \'f':     [':Files $HOME/.config/fish', 'Fish'],
        \}

  " Git
let g:leader_key_dict['g'] = {
      \'name':  'Git',
      \'b':     [':Gblame', 'Blame'],
      \'c':     [':Gcommit', 'Commit'],
      \'C':     [':Commits', 'List commits'],
      \'d':     [':Gvdiff', 'Diff'],
      \'e':     [':Extradite', 'Extradite'],
      \'l':     [':Gitv', 'Log'],
      \'s':     [':Gstatus', 'Status'],
      \'S':     [':Magit', 'Magit'],
      \}

  " Hunks
  let g:leader_key_dict['g']['h'] = {
        \'name':  'Hunk',
        \'n':     [':GitGutterNextHunk', 'Next'],
        \'p':     [':GitGutterPrevHunk', 'Previous'],
        \'P':     [':GitGutterPreviewHunk', 'Preview'],
        \'r':     [':GitGutterRevertHunk', 'Revert'],
        \'s':     [':GitGutterStageHunk', 'Stage'],
        \'u':     [':GitGutterUndoHunk', 'Undo'],
        \}

" Specs
let g:leader_key_dict['s'] = {
      \'name':  'Spec',
      \'f':     [':TestFile', 'File'],
      \'s':     [':TestNearest', 'Nearest']
      \}

" Tags
let g:leader_key_dict['t'] = {
      \'name':  'Tags',
      \'f':     [':Tags', 'Find tag'],
      \'b':     [':BTags', 'Buffer tags']
      \}

" ---------
" Filetypes
" ---------

" Rails

let g:leader_rails_dict = {}
let g:leader_rails_dict = {
      \'name':  'Main',
      \'c':     [':Econtroller', 'Controller'],
      \'f':     [':Efactory', 'Factory'],
      \'m':     [':Emodel', 'Model'],
      \'p':     [':Epolicy', 'Policy'],
      \'s':     [':Eservice', 'Service'],
      \'t':     [':Espec', 'Spec'],
      \'v':     [':Eview', 'View'],
      \}

  " Refactoring
  let g:leader_rails_dict['r'] = {
        \'name':  'Refactor',
        \'s':     [':Switch', 'Switch']
        \}

  " Lists
  let g:leader_rails_dict['l'] = {
        \'name':  'List',
        \'c':     [':Files app/controllers/', 'Controllers'],
        \'f':     [':Files spec/factories/', 'Factories'],
        \'m':     [':Files app/models/', 'Models'],
        \'p':     [':Files app/policies/', 'Policies'],
        \'s':     [':Files app/services/', 'Services'],
        \'t':     [':Files spec/', 'Specs'],
        \'v':     [':Files app/views/', 'Views'],
        \}

  " Open
  let g:leader_rails_dict['o'] = {
        \'name':  'Open',
        \'s':     [':Eschema', 'Schema'],
        \'r':     [':Einitializer', 'Routes'],
        \}

function! InitFiletypeLeaderMappings()
  if &filetype ==# 'ruby'
    let g:leader_key_dict['m'] = g:leader_rails_dict
  else
    if has_key(g:leader_key_dict, 'm')
      call remove(g:leader_key_dict, 'm')
    endif
  endif
endfunction

autocmd! BufEnter * call InitFiletypeLeaderMappings()

call leaderGuide#register_prefix_descriptions("<Space>", "g:leader_key_dict")

let mapleader = ""
nnoremap <silent> <Space> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <Space> :<c-u>LeaderGuideVisual '<Space>'<CR>
