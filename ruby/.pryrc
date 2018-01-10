def _copy(input)
  command = system('which pbcopy > /dev/null 2>&1') ? 'pbcopy' : 'xsel -ib'

  input.tap do
    system("echo #{input} | #{command}")
  end
end
