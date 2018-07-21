#!/bin/bash
uname | grep -q Darwin && tmux source-file $HOME/.tmux/conf/macos.conf || tmux source-file $HOME/.tmux/conf/nix.conf
