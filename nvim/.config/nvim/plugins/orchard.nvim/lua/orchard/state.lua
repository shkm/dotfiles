local M = {}

---@class orchard.TabState
---@field worktree orchard.Worktree
---@field tabnr number

---@type table<string, orchard.TabState>
local tab_states = {}

--- Find or create a tab for a worktree
---@param worktree orchard.Worktree
---@return number tabnr
local function get_or_create_tab(worktree)
  -- Check if we already have a tab for this worktree
  local state = tab_states[worktree.path]
  if state and vim.api.nvim_tabpage_is_valid(state.tabnr) then
    return state.tabnr
  end

  -- Create a new tab
  vim.cmd("tabnew")
  local tabnr = vim.api.nvim_get_current_tabpage()

  -- Set the tab-local cwd
  vim.cmd("tcd " .. vim.fn.fnameescape(worktree.path))

  -- Set tab name (tab-local variable, common convention for tabline plugins)
  vim.t[tabnr].name = worktree.branch

  -- Open file manager in the worktree directory
  vim.cmd("edit " .. vim.fn.fnameescape(worktree.path))

  -- Store state
  tab_states[worktree.path] = {
    worktree = worktree,
    tabnr = tabnr,
  }

  return tabnr
end

--- Open a worktree in a new tab
---@param worktree orchard.Worktree
function M.open_worktree(worktree)
  local config = require("orchard").get_config()
  local from = M.current_worktree()

  local tabnr = get_or_create_tab(worktree)
  vim.api.nvim_set_current_tabpage(tabnr)

  -- Run switch hook
  if config.hooks.on_switch then
    config.hooks.on_switch(from, worktree)
  end
end

--- Switch to a worktree (finds existing tab or creates new one)
---@param worktree orchard.Worktree
function M.switch_to(worktree)
  local config = require("orchard").get_config()
  local from = M.current_worktree()

  -- Check if there's an existing tab for this worktree
  local state = tab_states[worktree.path]
  if state and vim.api.nvim_tabpage_is_valid(state.tabnr) then
    vim.api.nvim_set_current_tabpage(state.tabnr)
  else
    -- Check all tabs to see if any has this cwd
    for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
      local tab_cwd = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabnr))
      if vim.fs.normalize(tab_cwd) == vim.fs.normalize(worktree.path) then
        vim.api.nvim_set_current_tabpage(tabnr)
        tab_states[worktree.path] = { worktree = worktree, tabnr = tabnr }

        if config.hooks.on_switch then
          config.hooks.on_switch(from, worktree)
        end
        return
      end
    end

    -- No existing tab, create one
    M.open_worktree(worktree)
    return
  end

  -- Run switch hook
  if config.hooks.on_switch then
    config.hooks.on_switch(from, worktree)
  end
end

--- Get the worktree for the current tab
---@return orchard.Worktree?
function M.current_worktree()
  local cwd = vim.fn.getcwd()
  local worktrees = require("orchard.git").list_worktrees()

  for _, wt in ipairs(worktrees) do
    if vim.fs.normalize(wt.path) == vim.fs.normalize(cwd) then
      return wt
    end
  end

  return nil
end

--- Get all tracked tab states
---@return table<string, orchard.TabState>
function M.get_states()
  -- Clean up invalid tabs
  for path, state in pairs(tab_states) do
    if not vim.api.nvim_tabpage_is_valid(state.tabnr) then
      tab_states[path] = nil
    end
  end
  return tab_states
end

--- Close a worktree tab and optionally remove the worktree
---@param worktree orchard.Worktree
---@param remove_worktree? boolean
function M.close_worktree(worktree, remove_worktree)
  local config = require("orchard").get_config()
  local state = tab_states[worktree.path]

  local function close_tab()
    if state and vim.api.nvim_tabpage_is_valid(state.tabnr) then
      -- Switch away first so we're not on the tab we're closing
      if vim.api.nvim_get_current_tabpage() == state.tabnr then
        vim.cmd("tabprevious")
      end
      local tabnr = vim.api.nvim_tabpage_get_number(state.tabnr)
      vim.cmd("tabclose " .. tabnr)
    end
    tab_states[worktree.path] = nil

    if config.hooks.on_destroy then
      config.hooks.on_destroy(worktree)
    end
  end

  if remove_worktree then
    local git = require("orchard.git")
    local wt_path = vim.fs.normalize(worktree.path)

    -- Check for uncommitted changes
    local status = git.worktree_status(wt_path)
    if status.staged > 0 or status.unstaged > 0 then
      vim.notify(
        "Worktree '" .. worktree.branch .. "' has uncommitted changes (" .. status.staged .. " staged, " .. status.unstaged .. " unstaged)",
        vim.log.levels.ERROR
      )
      return
    end

    -- Stop any overseer tasks running in this worktree
    local has_overseer, overseer = pcall(require, "overseer")
    if has_overseer then
      local tasks = overseer.list_tasks({
        status = overseer.STATUS.RUNNING,
        filter = function(task)
          return task.cwd and vim.fs.normalize(task.cwd) == wt_path
        end,
      })
      for _, task in ipairs(tasks) do
        vim.notify("Stopping task: " .. task.name, vim.log.levels.INFO)
        task:stop()
      end
      if #tasks > 0 then
        -- Give tasks a moment to stop before removing
        vim.defer_fn(function()
          M._do_remove_worktree(worktree, close_tab)
        end, 1000)
        return
      end
    end

    M._do_remove_worktree(worktree, close_tab)
  else
    close_tab()
  end
end

--- Perform the actual worktree removal
---@param worktree orchard.Worktree
---@param close_tab fun()
function M._do_remove_worktree(worktree, close_tab)
  local git = require("orchard.git")
  local wt_path = vim.fs.normalize(worktree.path)

  -- Wipe buffers under the worktree directory first so plugins like gitsigns
  -- detach before the directory is removed from disk
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and vim.startswith(vim.fs.normalize(name), wt_path) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end

  close_tab()

  vim.notify("Removing worktree: " .. worktree.branch .. "...", vim.log.levels.INFO)
  git.remove_worktree(worktree.path, true, function(ok, err)
    if not ok then
      vim.notify("Failed to remove worktree: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end
    vim.notify("Removed worktree: " .. worktree.branch, vim.log.levels.INFO)
  end)
end

return M
