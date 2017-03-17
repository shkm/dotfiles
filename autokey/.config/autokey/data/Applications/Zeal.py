# Requires wmctrl & xdotool
# Activates Zeal if it's not activated
# Minimize Zeal if it's activated

zeal_class = 'zeal.Zeal'
if window.get_active_class() == zeal_class:
  system.exec_command('xdotool windowminimize $(xdotool getactivewindow)')
else:
  window.activate(zeal_class, matchClass=True)