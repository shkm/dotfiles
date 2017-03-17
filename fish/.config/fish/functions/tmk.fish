function tmk -d "Kill a tmux session"
  tmux kill-session -t $argv;
end
