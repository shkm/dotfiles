function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory_name>"
        return 1
    end
    mkdir -p $argv[1]
    cd $argv[1]
end

function c
    set target $argv[1]

    # Resolve absolute path (fail if not resolvable)
    set -l path (realpath -- $target 2>/dev/null)

    # If it's a file, use its directory; otherwise keep as-is
    if ! test -d "$path"
        set path (dirname -- "$path")
    end

    cd -- "$path"
end

function tempe
    cd (mktemp -d)
    chmod -R 0700 .
    if test (count $argv) -eq 1
        mkdir -p $argv[1]
        cd $argv[1]
        chmod -R 0700 .
    end
end

function reload!
    set config $__fish_config_dir/config.fish
    echo "Reloading config from $config"
    source $config
end
