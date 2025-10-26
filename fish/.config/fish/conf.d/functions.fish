function mkcd
  if test (count $argv) -eq 0
    echo "Usage: mkcd <directory_name>"
    return 1
  end
  mkdir -p $argv[1]
  cd $argv[1]
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
