# Disable Homebrew's vendor snippet that auto-activates mise, so we control it
# here (user conf.d is sourced before vendor conf.d, so this wins).
set -gx MISE_FISH_AUTO_ACTIVATE 0

# Interactive shells get the full mise integration (cd-hook, wrapper); scripts
# only need PATH resolved for the cwd — one subprocess, not two.
if type -q mise
    if status is-interactive
        mise activate fish | source
    else
        mise hook-env -s fish | source
    end
end
