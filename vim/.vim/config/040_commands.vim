command! PrettyJson :%!python -m json.tool
command! OpenPwd :!open `pwd`
command! OpenLocate :!open -R %
command! -nargs=1 Open :!open <q-args>
command! -nargs=1 -complete=file DirvishRename :call DirvishRename(<q-args>)
command! ProfileStart :call ProfileStart()
command! ProfileStop :call ProfileStop()
command! Strip :call Strip()
