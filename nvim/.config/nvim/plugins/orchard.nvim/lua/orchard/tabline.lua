local M = {}

-- Cache worktrees (refreshed via clear_cache)
local worktrees_cache = nil

local function get_worktrees()
  if not worktrees_cache then
    local ok, git = pcall(require, "orchard.git")
    worktrees_cache = ok and git.list_worktrees() or {}
  end
  return worktrees_cache
end

--- Get the display name for a tab
--- Uses: vim.t.name > worktree branch > codediff context > cwd basename
---@param tabnr number Tab page number
---@param index? number Tab index (for fallback)
---@return string name The tab display name
---@return boolean is_diff Whether this is a codediff tab
function M.get_tab_name(tabnr, index)
  -- Check if codediff is available
  local codediff_lifecycle = nil
  pcall(function()
    codediff_lifecycle = require("codediff.ui.lifecycle")
  end)

  -- Check if this is a codediff tab
  local diff_session = codediff_lifecycle and codediff_lifecycle.get_session(tabnr)
  local is_diff = diff_session ~= nil

  local name
  if is_diff then
    -- For diff tabs, use vim.t.name or look up worktree from CodeDiff's git_root
    name = vim.t[tabnr].name
    if not name and codediff_lifecycle.get_git_context then
      local git_ctx = codediff_lifecycle.get_git_context(tabnr)
      if git_ctx and git_ctx.git_root then
        local normalized_root = vim.fs.normalize(git_ctx.git_root)
        for _, wt in ipairs(get_worktrees()) do
          if vim.fs.normalize(wt.path) == normalized_root then
            name = wt.branch
            break
          end
        end
      end
    end
    name = "[diff] " .. (name or "diff")
  else
    -- Get tab name (set by orchard) or fallback to worktree branch or cwd basename
    name = vim.t[tabnr].name
    if not name then
      local ok, cwd = pcall(vim.fn.getcwd, -1, tabnr)
      if ok and cwd then
        -- Try to find worktree matching this cwd
        local normalized_cwd = vim.fs.normalize(cwd)
        for _, wt in ipairs(get_worktrees()) do
          if vim.fs.normalize(wt.path) == normalized_cwd then
            name = wt.branch
            break
          end
        end
        -- Fallback to basename if no worktree match
        name = name or vim.fn.fnamemodify(cwd, ":t")
      else
        name = tostring(index or tabnr)
      end
    end
  end

  return name, is_diff
end

--- Clear the worktrees cache (call at start of render cycle)
function M.clear_cache()
  worktrees_cache = nil
end

return M
