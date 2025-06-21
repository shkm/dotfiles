fenv source "$HOME/.profile"

# A place to put transient settings that shouldn't be versioned
if test -f $HOME/.transient/fish.fish
    source $HOME/.transient/fish.fish
end

if test -f $HOME/.orbstack/shell/init2.fish
    # orbstack
    source $HOME/.orbstack/shell/init2.fish 2>/dev/null || :
end

# Disable greeting
set -U fish_greeting

# FZF's legacy keybindings conflict with Fish
set -U FZF_LEGACY_KEYBINDINGS 0

# mise
if type -q mise
    mise activate fish | source
end

if status is-interactive
    if type -q zoxide
        zoxide init fish | source
    end

    if type -q oh-my-posh
        oh-my-posh init fish --config "$HOME/.config/oh-my-posh/catppuccin_latte.omp.json" | source
    end

    if test -f $HOME/.atuin/bin/env.fish
        source $HOME/.atuin/bin/env.fish
        atuin init fish --disable-up-arrow --disable-ctrl-r | source
    end

    abbr cat bat
    abbr dc docker compose
    abbr dka "docker kill (docker ps -q)"
    abbr dsa "docker stop (docker ps -q)"
    abbr ducks "du -cksh * | sort -hr"
    abbr g git
    abbr gcd "cd (git rev-parse --show-toplevel)"
    abbr gsha 'git rev-parse HEAD'
    abbr ll eza -lga --group-directories-first
    abbr ls ll
    abbr sshkey "clip $HOME/.ssh/id_ed25519.pub"
    abbr rm trash
    abbr v nvim
    abbr v. "nvim ."
    abbr z. "zed ."
    abbr vim nvim
    abbr be bundle exec
    abbr dcps docker compose ps --format \"table {{.ID}}\t{{.Service}}\t{{.Status}}\"
    abbr dcpsa docker compose ps --all --format \"table {{.ID}}\t{{.Service}}\t{{.Status}}\"
    abbr lg lazygit
    abbr lgh lazygit log -f

    # Bindings
    bind \cX edit_command_buffer

    # FZF bindings but we disable history and use atuin instead.
    fzf_configure_bindings --directory=\ct --processes=\cs --git_log=\cg --history=

    # Atuin fzf search. TODO: move elsewhere.
    function _atuin_fzf_search
        set -f commands_selected (
    atuin search --cmd-only --reverse |
    _fzf_wrapper --height=~20 \
    --query=(commandline) \
    )

        if test $status -eq 0
            commandline --replace -- $commands_selected
        end

        commandline --function repaint

    end

    bind \cR _atuin_fzf_search
end
