#!/bin/bash
uname | grep -q Darwin && tmux source-file $HOME/conf/macos.conf || tmux source-file $HOME/conf/nix.conf
