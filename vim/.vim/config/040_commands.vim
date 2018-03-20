command! PrettyJson :%!python -m json.tool
command! OpenPwd :!xdg-open `pwd`
command! OpenLocate :!xdg-open -R %
command! -nargs=1 Open :!xdg-open <q-args>
command! -nargs=1 -complete=file DirvishRename :call DirvishRename(<q-args>)
command! DirvishTrash :call DirvishTrash()
command! ProfileStart :call ProfileStart()
command! ProfileStop :call ProfileStop()
command! Strip :call Strip()
command! StripColours :call StripColours()
command! Trash :call Trash()
