# Load fish plugins from ~/.local/share/fish-plugins/*/
set --query _fish_plugins_initialized && exit
set --global _fish_plugins_initialized

if not set --query fish_plugins_path
    exit
end

for plugin_dir in $fish_plugins_path/*/
    test -d "$plugin_dir/functions" && set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..]
    test -d "$plugin_dir/completions" && set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..]
    test -d "$plugin_dir/themes" && set fish_complete_path $fish_complete_path # themes are auto-discovered

    for file in $plugin_dir/conf.d/*.fish
        if ! test -f (string replace --regex "^.*/" $__fish_config_dir/conf.d/ -- $file)
            and test -f $file && test -r $file
            source $file
        end
    end
end
