---@class orchard.Config
---@field hooks? orchard.Hooks

---@class orchard.Hooks
---@field on_create? fun(worktree: orchard.Worktree)
---@field on_destroy? fun(worktree: orchard.Worktree)
---@field on_switch? fun(from: orchard.Worktree?, to: orchard.Worktree)

---@class orchard.Worktree
---@field path string
---@field branch string
---@field is_main boolean
---@field is_current boolean

local M = {}

---@type orchard.Config
local config = {
  hooks = {},
}

---@param opts? orchard.Config
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  -- Create user commands
  vim.api.nvim_create_user_command("Orchard", function(cmd)
    local subcmd = cmd.fargs[1]
    if subcmd == "create" then
      M.create(cmd.fargs[2])
    elseif subcmd == "switch" then
      M.switch(cmd.fargs[2])
    elseif subcmd == "list" then
      M.list()
    elseif subcmd == "merge" then
      M.merge()
    elseif subcmd == "diff" then
      M.diff()
    elseif subcmd == "delete" then
      M.delete()
    elseif subcmd == "pick" then
      M.pick()
    else
      M.pick()
    end
  end, {
    nargs = "*",
    complete = function(_, line)
      local args = vim.split(line, "%s+")
      if #args == 2 then
        return { "create", "switch", "merge", "diff", "delete", "list", "pick" }
      end
      return {}
    end,
  })
end

--- Get the plugin configuration
---@return orchard.Config
function M.get_config()
  return config
end

--- List all worktrees
---@return orchard.Worktree[]
function M.worktrees()
  return require("orchard.git").list_worktrees()
end

--- Create a new worktree
---@param name? string Branch name (prompts if not provided)
function M.create(name)
  local git = require("orchard.git")
  local state = require("orchard.state")

  local function do_create(branch)
    if not branch or branch == "" then
      return
    end

    vim.notify("Creating worktree: " .. branch .. "...", vim.log.levels.INFO)
    git.create_worktree(branch, nil, function(worktree, err)
      if not worktree then
        vim.notify("Failed to create worktree: " .. (err or "unknown error"), vim.log.levels.ERROR)
        return
      end

      -- Run hook
      if config.hooks.on_create then
        config.hooks.on_create(worktree)
      end

      -- Open in new tab
      state.open_worktree(worktree)

      vim.notify("Created worktree: " .. branch, vim.log.levels.INFO)
    end)
  end

  if name then
    do_create(name)
  else
    vim.ui.input({ prompt = "Branch name: " }, do_create)
  end
end

--- Switch to a worktree
---@param path? string Worktree path (prompts if not provided)
function M.switch(path)
  local state = require("orchard.state")

  if path then
    local worktrees = M.worktrees()
    for _, wt in ipairs(worktrees) do
      if wt.path == path or wt.branch == path then
        state.switch_to(wt)
        return
      end
    end
    vim.notify("Worktree not found: " .. path, vim.log.levels.ERROR)
  else
    M.pick()
  end
end

--- Show worktree picker
function M.pick()
  local git = require("orchard.git")
  local state = require("orchard.state")
  local worktrees = M.worktrees()

  if #worktrees == 0 then
    vim.notify("No worktrees found", vim.log.levels.WARN)
    return
  end

  -- Use snacks.picker if available, otherwise vim.ui.select
  local has_snacks, snacks = pcall(require, "snacks")
  if has_snacks and snacks.picker then
    snacks.picker({
      title = "Worktrees",
      items = vim.tbl_map(function(wt)
        return {
          text = wt.branch .. " (" .. wt.path .. ")",
          worktree = wt,
        }
      end, worktrees),
      format = function(item)
        local wt = item.worktree
        local icon = wt.is_current and "" or ""
        return { { icon .. " " .. wt.branch, wt.is_current and "DiagnosticOk" or "Normal" } }
      end,
      preview = function(ctx)
        local item = ctx.item
        local wt = item and item.worktree
        if not wt then
          ctx.preview:reset()
          ctx.preview:set_lines({ "No worktree selected" })
          return
        end

        local lines = {}
        local highlights = {} -- { row, col_start, col_end, hl_group }

        -- Branch header
        table.insert(lines, " " .. wt.branch)
        table.insert(highlights, { #lines, 0, -1, "Title" })

        -- Path (dimmed)
        table.insert(lines, "  " .. wt.path)
        table.insert(highlights, { #lines, 0, -1, "Comment" })

        table.insert(lines, "")

        -- Git status (fetch full details for preview)
        local status = git.worktree_status(wt.path)
        local changes = status.staged + status.unstaged + status.untracked
        if changes > 0 then
          local status_parts = {}
          if status.staged > 0 then
            table.insert(status_parts, status.staged .. " staged")
          end
          if status.unstaged > 0 then
            table.insert(status_parts, status.unstaged .. " modified")
          end
          if status.untracked > 0 then
            table.insert(status_parts, status.untracked .. " untracked")
          end
          table.insert(lines, " " .. table.concat(status_parts, ", "))
          table.insert(highlights, { #lines, 0, -1, "DiagnosticWarn" })
        else
          table.insert(lines, " No uncommitted changes")
          table.insert(highlights, { #lines, 0, -1, "DiagnosticOk" })
        end

        table.insert(lines, "")

        -- Commits ahead of main (fetch full details for preview)
        if not wt.is_main then
          local main = git.main_branch()
          local commits = git.commits_ahead(wt.path, wt.branch)
          if #commits > 0 then
            table.insert(lines, " " .. #commits .. " commit" .. (#commits > 1 and "s" or "") .. " ahead of " .. main)
            table.insert(highlights, { #lines, 0, -1, "DiagnosticInfo" })
            table.insert(lines, "")
            for _, commit in ipairs(commits) do
              -- Format: "abc1234 commit message"
              local hash = commit:match("^(%S+)")
              local msg = commit:match("^%S+%s+(.*)") or ""
              table.insert(lines, "  " .. (hash or "") .. " " .. msg)
              -- Highlight just the hash
              if hash then
                table.insert(highlights, { #lines, 2, 2 + #hash, "Identifier" })
              end
            end
          else
            table.insert(lines, " Up to date with " .. main)
            table.insert(highlights, { #lines, 0, -1, "DiagnosticOk" })
          end
        else
          table.insert(lines, " Main branch")
          table.insert(highlights, { #lines, 0, -1, "Special" })
        end

        ctx.preview:reset()
        ctx.preview:set_lines(lines)

        -- Apply highlights
        local ns = vim.api.nvim_create_namespace("orchard.preview")
        for _, hl in ipairs(highlights) do
          local row, col_start, col_end, hl_group = hl[1], hl[2], hl[3], hl[4]
          vim.api.nvim_buf_set_extmark(ctx.buf, ns, row - 1, col_start, {
            end_col = col_end == -1 and #lines[row] or col_end,
            hl_group = hl_group,
          })
        end
      end,
      confirm = function(picker, item)
        picker:close()
        if item then
          state.switch_to(item.worktree)
        end
      end,
      actions = {
        create = function(picker)
          picker:close()
          M.create()
        end,
        delete = function(picker)
          local item = picker:current()
          if not item or not item.worktree then
            return
          end
          local wt = item.worktree
          if wt.is_main then
            vim.notify("Cannot delete main worktree", vim.log.levels.ERROR)
            return
          end
          picker:close()
          vim.ui.select({ "Yes", "No" }, {
            prompt = "Delete worktree '" .. wt.branch .. "'?",
          }, function(choice)
            if choice == "Yes" then
              state.close_worktree(wt, true)
              vim.notify("Deleted worktree: " .. wt.branch, vim.log.levels.INFO)
            end
          end)
        end,
        merge = function(picker)
          local item = picker:current()
          if not item or not item.worktree then
            return
          end
          local wt = item.worktree
          if wt.is_main then
            vim.notify("Cannot merge main into itself", vim.log.levels.ERROR)
            return
          end
          picker:close()
          M.merge_worktree(wt)
        end,
      },
      win = {
        input = {
          keys = {
            ["c"] = { "create", mode = { "n" }, desc = "Create worktree" },
            ["d"] = { "delete", mode = { "n" }, desc = "Delete worktree" },
            ["m"] = { "merge", mode = { "n" }, desc = "Merge to main" },
          },
        },
      },
    })
  else
    vim.ui.select(worktrees, {
      prompt = "Select worktree:",
      format_item = function(wt)
        local prefix = wt.is_current and "* " or "  "
        return prefix .. wt.branch
      end,
    }, function(wt)
      if wt then
        state.switch_to(wt)
      end
    end)
  end
end

--- Merge a specific worktree branch into main
---@param worktree orchard.Worktree
function M.merge_worktree(worktree)
  local git = require("orchard.git")
  local state = require("orchard.state")

  -- Check for uncommitted changes
  local status = git.worktree_status(worktree.path)
  if status.staged > 0 or status.unstaged > 0 then
    vim.notify("Worktree has uncommitted changes", vim.log.levels.ERROR)
    return
  end

  -- Get main worktree path
  local main_path = git.main_worktree_path()
  if not main_path then
    vim.notify("Could not find main worktree", vim.log.levels.ERROR)
    return
  end

  -- Confirm merge
  local branch = worktree.branch
  vim.ui.select({ "Yes", "No" }, {
    prompt = "Merge '" .. branch .. "' into main?",
  }, function(choice)
    if choice ~= "Yes" then
      return
    end

    -- Perform merge
    local ok, err = git.merge_branch(branch, main_path)
    if not ok then
      -- Check if it's a merge conflict
      if err and err:match("conflict") then
        vim.notify("Merge conflict detected", vim.log.levels.WARN)
        vim.ui.select({ "Resolve with AI", "Resolve manually", "Abort merge" }, {
          prompt = "Merge conflict in main worktree",
        }, function(choice)
          if choice == "Abort merge" then
            local abort_ok, abort_err = git.abort_merge(main_path)
            if abort_ok then
              vim.notify("Merge aborted", vim.log.levels.INFO)
            else
              vim.notify("Failed to abort: " .. (abort_err or ""), vim.log.levels.ERROR)
            end
            return
          end

          if choice == "Resolve manually" then
            vim.notify("Resolve conflicts in: " .. main_path, vim.log.levels.INFO)
            return
          end

          if choice ~= "Resolve with AI" then
            return
          end

          -- Get conflicted files
          local conflicted = git.conflicted_files(main_path)
          if #conflicted == 0 then
            vim.notify("No conflicted files found", vim.log.levels.WARN)
            return
          end

          -- Build a prompt for the AI
          local prompt_lines = {
            "I have a merge conflict merging `" .. branch .. "` into `" .. git.main_branch() .. "`.",
            "",
            "Conflicted files:",
          }
          for _, file in ipairs(conflicted) do
            table.insert(prompt_lines, "- " .. file)
          end
          table.insert(prompt_lines, "")
          table.insert(prompt_lines, "Please resolve the conflicts, keeping the intended changes from both sides where appropriate.")

          local prompt = table.concat(prompt_lines, "\n")

          -- Try to open Claude Code and send the prompt directly
          local has_claude_code = pcall(vim.cmd, "ClaudeCode")
          if has_claude_code then
            -- Poll for terminal to initialize (every 200ms, up to 5 seconds)
            local attempts = 0
            local max_attempts = 25
            local function try_send()
              attempts = attempts + 1
              local chan = vim.b.terminal_job_id
              if chan then
                vim.fn.chansend(chan, prompt)
                vim.notify("Merge prompt sent to Claude Code", vim.log.levels.INFO)
              elseif attempts < max_attempts then
                vim.defer_fn(try_send, 200)
              else
                -- Timed out, fall back to register
                vim.fn.setreg('"', prompt)
                vim.notify("Claude Code not ready. Prompt ready to paste with p", vim.log.levels.WARN)
              end
            end
            vim.defer_fn(try_send, 200)
          else
            -- No Claude Code, put in unnamed register for p
            vim.fn.setreg('"', prompt)
            vim.notify("Prompt ready to paste with p", vim.log.levels.INFO)
          end
        end)
        return
      end

      vim.notify("Merge failed: " .. (err or "unknown error"), vim.log.levels.ERROR)
      return
    end

    vim.notify("Merged '" .. branch .. "' into main", vim.log.levels.INFO)

    -- Ask about cleanup
    vim.ui.select({ "Yes", "No" }, {
      prompt = "Delete worktree and branch?",
    }, function(cleanup_choice)
      if cleanup_choice ~= "Yes" then
        return
      end

      -- Close and remove worktree
      local ok = state.close_worktree(worktree, true)
      if not ok then
        return
      end

      -- Delete the branch
      local branch_ok, branch_err = git.delete_branch(branch, true)
      if not branch_ok then
        vim.notify("Worktree removed but branch delete failed: " .. (branch_err or ""), vim.log.levels.WARN)
      else
        vim.notify("Cleaned up worktree and branch", vim.log.levels.INFO)
      end

    end)
  end)
end

--- Merge current worktree branch into main
function M.merge()
  local state = require("orchard.state")

  -- Get current worktree
  local current = state.current_worktree()
  if not current then
    vim.notify("Not in a worktree", vim.log.levels.ERROR)
    return
  end

  if current.is_main then
    vim.notify("Already on main branch", vim.log.levels.WARN)
    return
  end

  M.merge_worktree(current)
end

--- Delete current worktree
function M.delete()
  local state = require("orchard.state")

  local current = state.current_worktree()
  if not current then
    vim.notify("Not in a worktree", vim.log.levels.ERROR)
    return
  end

  if current.is_main then
    vim.notify("Cannot delete main worktree", vim.log.levels.ERROR)
    return
  end

  vim.ui.select({ "Yes", "No" }, {
    prompt = "Delete worktree '" .. current.branch .. "'?",
  }, function(choice)
    if choice ~= "Yes" then
      return
    end

    state.close_worktree(current, true)
  end)
end

--- Diff current worktree against main branch
function M.diff()
  local git = require("orchard.git")
  local state = require("orchard.state")

  local current = state.current_worktree()
  if not current then
    vim.notify("Not in a worktree", vim.log.levels.ERROR)
    return
  end

  local main = git.main_branch()

  -- Use codediff.nvim for PR-like diff view (main vs worktree)
  local has_codediff = pcall(require, "codediff")
  if has_codediff then
    vim.cmd("CodeDiff " .. main .. " HEAD")
  else
    vim.notify("codediff.nvim not installed", vim.log.levels.ERROR)
  end
end

--- List worktrees in a floating window
function M.list()
  local worktrees = M.worktrees()
  local lines = {}
  for _, wt in ipairs(worktrees) do
    local prefix = wt.is_current and "* " or "  "
    table.insert(lines, prefix .. wt.branch .. " -> " .. wt.path)
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

return M
