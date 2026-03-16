if status is-interactive
  bind \cX edit_command_buffer

  if functions -q fzf_configure_bindings
    fzf_configure_bindings --directory=\ct --processes=\cs --git_log=\cg
  end
end
