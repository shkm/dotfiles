fundle plugin 'shkm/vssh'
fundle plugin 'shkm/fish-vimple'
fundle plugin 'fisherman/rvm'

[ (uname) = Darwin ]; and source $HOME/.config/fish/bundles/macos.fish
[ (uname -r | grep Microsoft) ]; and source $HOME/.config/fish/bundles/windows.fish

fundle init
