require 'rubygems'

if defined?(Bundler)
  gems = %w[pry-inline awesome_print]

  Gem.path.each do |path|
    $LOAD_PATH.concat Dir.glob("#{path}/gems/{#{gems.join(',')}}-*/lib")
  end

  $LOAD_PATH.uniq!

  gems.each(&method(:require))
end

AwesomePrint.pry!

Pry.commands.alias_command "@", "whereami"
Pry.commands.alias_command "n", "next"
Pry.commands.alias_command "c", "continue"
Pry.commands.alias_command "s", "step"
Pry.commands.alias_command "Q", "!!!"
# Pry.commands.alias_command "!!", "exit!"

def pbcopy
  command = system('which pbcopy > /dev/null 2>&1') ? 'pbcopy' : 'xsel -ib'

  self.tap do
    system %(echo "#{self.to_s}" | #{command})
  end
end

# Hit Enter to repeat last command
Pry::Commands.command /^$/, "repeat last command" do  
  _pry_.input = StringIO.new(Pry.history.to_a.last)
end
