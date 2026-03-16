local M = {}

--- Get the git root directory
---@return string?
function M.git_root()
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

--- Get the git common directory (for bare repos, this is the repo root)
---@return string?
function M.git_common_dir()
  local result = vim.system({ "git", "rev-parse", "--git-common-dir" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  local dir = vim.trim(result.stdout)
  -- Make absolute if relative
  if not vim.startswith(dir, "/") then
    local cwd = vim.fn.getcwd()
    dir = vim.fs.normalize(cwd .. "/" .. dir)
  end
  return dir
end

--- Check if we're in a bare repo
---@return boolean
function M.is_bare_repo()
  local result = vim.system({ "git", "rev-parse", "--is-bare-repository" }, { text = true }):wait()
  return result.code == 0 and vim.trim(result.stdout) == "true"
end

--- Get the current branch name
---@return string?
function M.current_branch()
  local result = vim.system({ "git", "branch", "--show-current" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

--- Get the main branch name
---@return string
function M.main_branch()
  -- Try common main branch names
  for _, name in ipairs({ "main", "master", "trunk" }) do
    local result = vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. name }):wait()
    if result.code == 0 then
      return name
    end
  end
  return "main"
end

--- List all worktrees
---@return orchard.Worktree[]
function M.list_worktrees()
  local result = vim.system({ "git", "worktree", "list", "--porcelain" }, { text = true }):wait()
  if result.code ~= 0 then
    return {}
  end

  local worktrees = {}
  local current = {}
  local current_path = vim.fn.getcwd()
  local main_branch = M.main_branch()

  for line in vim.gsplit(result.stdout, "\n") do
    if vim.startswith(line, "worktree ") then
      current.path = line:sub(10)
    elseif vim.startswith(line, "branch ") then
      -- Extract branch name from refs/heads/...
      local ref = line:sub(8)
      current.branch = ref:gsub("^refs/heads/", "")
    elseif line == "" and current.path then
      current.is_main = current.branch == main_branch
      current.is_current = vim.fs.normalize(current.path) == vim.fs.normalize(current_path)
      table.insert(worktrees, current)
      current = {}
    end
  end

  return worktrees
end

--- Create a new worktree
---@param branch string
---@param base_branch? string Branch to base off (defaults to main)
---@param callback? fun(worktree?: orchard.Worktree, err?: string) If provided, runs async
---@return orchard.Worktree?, string?
function M.create_worktree(branch, base_branch, callback)
  -- Use main worktree path so we never nest worktrees inside each other
  local root = M.main_worktree_path()
  if not root then
    if callback then
      callback(nil, "Not in a git repository")
      return nil
    end
    return nil, "Not in a git repository"
  end

  base_branch = base_branch or M.main_branch()

  -- Determine worktree path (.worktrees/<branch> inside main worktree)
  local worktrees_dir = root .. "/.worktrees"
  local worktree_path = worktrees_dir .. "/" .. branch

  -- Create .worktrees directory if it doesn't exist
  vim.fn.mkdir(worktrees_dir, "p")

  -- Check if path already exists
  if vim.fn.isdirectory(worktree_path) == 1 then
    local err = "Directory already exists: " .. worktree_path
    if callback then
      callback(nil, err)
      return nil
    end
    return nil, err
  end

  ---@type orchard.Worktree
  local worktree = {
    path = worktree_path,
    branch = branch,
    is_main = false,
    is_current = false,
  }

  local function try_existing_branch(cb)
    local args = { "git", "worktree", "add", worktree_path, branch }
    if cb then
      vim.system(args, { text = true }, function(result)
        vim.schedule(function()
          if result.code ~= 0 then
            cb(nil, result.stderr or "Failed to create worktree")
          else
            cb(worktree, nil)
          end
        end)
      end)
    else
      local result = vim.system(args, { text = true }):wait()
      if result.code ~= 0 then
        return nil, result.stderr or "Failed to create worktree"
      end
      return worktree, nil
    end
  end

  -- Create the worktree with a new branch
  local args = { "git", "worktree", "add", "-b", branch, worktree_path, base_branch }

  if callback then
    vim.system(args, { text = true }, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          -- Maybe branch already exists, try without -b
          try_existing_branch(callback)
        else
          callback(worktree, nil)
        end
      end)
    end)
    return nil
  end

  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    -- Maybe branch already exists, try without -b
    return try_existing_branch(nil)
  end

  return worktree, nil
end

--- Remove a worktree
---@param path string
---@param force? boolean
---@param callback? fun(ok: boolean, err?: string) If provided, runs async
---@return boolean?, string?
function M.remove_worktree(path, force, callback)
  local args = { "git", "worktree", "remove" }
  if force then
    table.insert(args, "--force")
  end
  table.insert(args, path)

  if callback then
    vim.system(args, { text = true }, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          callback(false, result.stderr or "Failed to remove worktree")
        else
          callback(true, nil)
        end
      end)
    end)
    return nil
  end

  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    return false, result.stderr or "Failed to remove worktree"
  end
  return true, nil
end

--- Get git status for a worktree
---@param path string
---@return { staged: number, unstaged: number, untracked: number }
function M.worktree_status(path)
  local result = vim.system(
    { "git", "-C", path, "status", "--porcelain" },
    { text = true }
  ):wait()

  local status = { staged = 0, unstaged = 0, untracked = 0 }
  if result.code ~= 0 then
    return status
  end

  for line in vim.gsplit(result.stdout, "\n") do
    if #line >= 2 then
      local index = line:sub(1, 1)
      local work = line:sub(2, 2)
      if index == "?" then
        status.untracked = status.untracked + 1
      else
        if index ~= " " then
          status.staged = status.staged + 1
        end
        if work ~= " " then
          status.unstaged = status.unstaged + 1
        end
      end
    end
  end

  return status
end

--- Get the main worktree path
---@return string?
function M.main_worktree_path()
  local worktrees = M.list_worktrees()
  for _, wt in ipairs(worktrees) do
    if wt.is_main then
      return wt.path
    end
  end
  return nil
end

--- Merge a branch into main
---@param branch string
---@param main_path string Path to main worktree
---@return boolean success
---@return string? error
function M.merge_branch(branch, main_path)
  -- First, check if main has uncommitted changes
  local status = M.worktree_status(main_path)
  if status.staged > 0 or status.unstaged > 0 then
    return false, "Main worktree has uncommitted changes"
  end

  -- Fetch latest (optional, but good practice)
  vim.system({ "git", "-C", main_path, "fetch" }, { text = true }):wait()

  -- Merge the branch
  local result = vim.system({
    "git", "-C", main_path, "merge", branch, "--no-edit",
  }, { text = true }):wait()

  if result.code ~= 0 then
    -- Check if it's a conflict
    if result.stdout and result.stdout:match("CONFLICT") then
      return false, "Merge conflict - resolve manually in main worktree"
    end
    return false, result.stderr or "Merge failed"
  end

  return true, nil
end

--- Get list of files with merge conflicts
---@param path string Worktree path
---@return string[]
function M.conflicted_files(path)
  local result = vim.system({
    "git", "-C", path, "diff", "--name-only", "--diff-filter=U",
  }, { text = true }):wait()

  local files = {}
  if result.code == 0 and result.stdout then
    for line in vim.gsplit(result.stdout, "\n") do
      if line ~= "" then
        table.insert(files, path .. "/" .. line)
      end
    end
  end
  return files
end

--- Get count of commits ahead of main branch (fast, just returns number)
---@param path string Worktree path
---@param branch string Branch name
---@return number
function M.commits_ahead_count(path, branch)
  local main = M.main_branch()
  local result = vim.system({
    "git", "-C", path, "rev-list", "--count", main .. ".." .. branch,
  }, { text = true }):wait()

  if result.code == 0 and result.stdout then
    return tonumber(vim.trim(result.stdout)) or 0
  end
  return 0
end

--- Get commits ahead of main branch for a worktree (full details)
---@param path string Worktree path
---@param branch string Branch name
---@return string[]
function M.commits_ahead(path, branch)
  local main = M.main_branch()
  local result = vim.system({
    "git", "-C", path, "log", "--oneline", main .. ".." .. branch,
  }, { text = true }):wait()

  local commits = {}
  if result.code == 0 and result.stdout then
    for line in vim.gsplit(result.stdout, "\n") do
      if line ~= "" then
        table.insert(commits, line)
      end
    end
  end

  return commits
end

--- Check if worktree has any changes (fast, just returns boolean)
---@param path string Worktree path
---@return boolean
function M.is_dirty(path)
  local result = vim.system({ "git", "-C", path, "status", "--porcelain" }, { text = true }):wait()
  return result.code == 0 and result.stdout ~= nil and result.stdout ~= ""
end

--- Abort an in-progress merge
---@param path string Worktree path
---@return boolean success
---@return string? error
function M.abort_merge(path)
  local result = vim.system({
    "git", "-C", path, "merge", "--abort",
  }, { text = true }):wait()

  if result.code ~= 0 then
    return false, result.stderr or "Failed to abort merge"
  end
  return true, nil
end

--- Delete a branch
---@param branch string
---@param force? boolean
---@return boolean success
---@return string? error
function M.delete_branch(branch, force)
  local flag = force and "-D" or "-d"
  local result = vim.system({
    "git", "branch", flag, branch,
  }, { text = true }):wait()

  if result.code ~= 0 then
    return false, result.stderr or "Failed to delete branch"
  end
  return true, nil
end

return M
