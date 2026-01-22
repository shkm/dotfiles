if status is-interactive
    abbr cat bat
    abbr dc docker compose
    abbr dka "docker kill (docker ps -q)"
    abbr dsa "docker stop (docker ps -q)"
    abbr ducks "du -cksh * | sort -hr"
    abbr g git
    abbr gcd "cd (git rev-parse --show-toplevel)"
    abbr gsha 'git rev-parse HEAD'
    alias ll "eza -lga --group-directories-first"
    abbr ls ll
    abbr o open
    abbr o. "open ."
    abbr sshkey "clip $HOME/.ssh/id_ed25519.pub"
    abbr rm trash
    abbr v nvim
    abbr v. "nvim ."
    abbr z. "zed ."
    abbr y yazi
    abbr vim nvim
    abbr be bundle exec
    abbr dcps docker compose ps --format \"table {{.ID}}\t{{.Service}}\t{{.Status}}\"
    abbr dcpsa docker compose ps --all --format \"table {{.ID}}\t{{.Service}}\t{{.Status}}\"
    abbr lg lazygit
    abbr lgh lazygit log -f
    abbr art php artisan
end
