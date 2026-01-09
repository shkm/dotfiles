# Completions for wt (git worktree helper)

function __wt_worktrees
    set -l worktree_base "$HOME/.worktrees"
    set -l project ""

    # Get project name from git remote or directory
    if not git rev-parse --git-dir &>/dev/null
        return
    end

    set -l remote_url (git remote get-url origin 2>/dev/null)
    if test -n "$remote_url"
        set project (basename -s .git "$remote_url")
    else
        set project (basename (git rev-parse --show-toplevel))
    end

    set -l project_path "$worktree_base/$project"
    if test -d "$project_path"
        for dir in $project_path/*/
            basename $dir
        end
    end
end

# Commands
complete -c wt -f
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "new n" -d "Create a new worktree"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "remove r" -d "Remove a worktree"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "merge m" -d "Merge branch into main"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "list l" -d "List worktrees"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "find f" -d "Fuzzy-find a worktree"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "exec e" -d "Run command in worktree"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "claude c" -d "Open Claude in worktree"
complete -c wt -n "not __fish_seen_subcommand_from new n remove r merge m list l find f exec e claude c lg" -a "lg" -d "Open lazygit in worktree"

# Worktree name completions for commands that need them
complete -c wt -n "__fish_seen_subcommand_from remove r merge m find f exec e claude c lg" -a "(__wt_worktrees)"
