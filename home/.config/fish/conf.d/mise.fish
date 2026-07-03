# Homebrew's mise formula ships a vendor conf.d snippet (mise-activate.fish)
# that force-runs full `mise activate` in every fish shell. Fish sources user
# conf.d before vendor conf.d, so setting this here disables that snippet before
# it runs, letting us choose the activation mode ourselves below.
set -gx MISE_FISH_AUTO_ACTIVATE 0

# Use shims in every fish shell. fish is the login shell ($SHELL via dscl), and
# GUI apps launched from the Dock (Claude, etc.) capture their environment by
# running it *interactively*. Full `activate` would hand them a frozen PATH
# snapshot pinned to $HOME's "latest" version; shims resolve the correct
# per-project version at exec time, so the captured PATH stays correct.
# (Trade-off: no full-activate niceties in the terminal — but we don't use the
# [env]-var / direct-bin features that would require.)
# See: https://mise.jdx.dev/dev-tools/shims.html
if type -q mise
    mise activate fish --shims | source
end
