def pbcopy
  command = system('which pbcopy > /dev/null 2>&1') ? 'pbcopy' : 'xsel -ib'

  self.tap do
    system %(echo "#{self.to_s}" | #{command})
  end
end
