# .secrets should NOT be committed to version control.
if [ -f "$HOME/.secrets" ]; then
  source $HOME/.secrets
fi

export EDITOR='nvim'
