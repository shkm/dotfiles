if [ -f "/opt/asdf-vm/asdf.sh" ]; then
  source "/opt/asdf-vm/asdf.sh"
elif [ -f "$HOME/.asdf/asdf.sh" ]; then
  source "$HOME/.asdf/asdf.sh"
fi

fpath=(${ASDF_DIR}/completions $fpath)
