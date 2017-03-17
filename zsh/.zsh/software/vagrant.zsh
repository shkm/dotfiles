# vim: foldmethod=marker:

# Functions {{{
# Execute vagrant sub-commands as normal.
# Any other commands are passed onto the box with `vssh`.
v() {
  vagrant_commands=(box connect destroy global-status halt help init login
                    package plugin port powershell provision push rdp reload
                    resumescp share snapshot ssh-config status suspend up
                    version rsync-auto fsnotify)
  if [[ -z "${*}" || "${@}" == "ssh" ]]; then
    vssh
  elif [[ "${vagrant_commands[(r)$1]}" == "$1" ]]; then
    vagrant $*
  else
    vssh "${@}"
  fi
}

# Suspend all running boxes.
vsall() {
  vagrant global-status --prune | grep running | awk '{system("vagrant suspend "$1)}'
}

# Halt all running boxes.
vhall() {
  vagrant global-status | grep running | awk '{print $1}' | xargs -L1 -I {} vagrant halt {}
  VBoxManage list runningvms | sed -r "s/.*\{(.*)\}/\1/" | xargs -L1 -I {} VBoxManage controlvm {} poweroff
}

# Alias some stuff to have it run under vssh
alias bundle='vssh bundle'
alias rake='vssh rake'
# }}}
