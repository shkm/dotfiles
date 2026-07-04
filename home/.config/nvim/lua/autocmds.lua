-- Autocommands

-- Returns the current theme name (e.g. "ayu-dark").
function _G.current_theme()
  local handle = io.popen("dark-mode status")
  if handle then
    local status = handle:read("*l")
    handle:close()
    if status == "on" then
      return os.getenv("DARK_MODE_THEME") or "ayu-dark"
    else
      return os.getenv("LIGHT_MODE_THEME") or "ayu-light"
    end
  end
  return "ayu-dark"
end

-- UI accent colors for statusline/tabline/Claude border. Sourced from the
-- current theme's nvim.lua so dark/light toggles and theme-switch both
-- take effect without nvim restart.
local function load_theme_meta()
  local theme = _G.current_theme()
  local path = os.getenv("HOME") .. "/.config/themes/" .. theme .. "/nvim.lua"
  local ok, mod = pcall(dofile, path)
  if ok and type(mod) == "table" then
    return mod
  end
  return nil
end

function _G.ui_palette()
  local meta = load_theme_meta()
  if meta and meta.palette then
    return meta.palette
  end
  -- Fallback so UI doesn't break if the active theme dir is missing nvim.lua.
  return {
    panel_bg = "#1f2335", panel_fill = "#24283b",
    accent = "#7aa2f7", muted = "#9aa5ce",
    faint = "#565f89", ok = "#9ece6a",
  }
end

function _G.lualine_theme_name()
  local meta = load_theme_meta()
  if meta and meta.lualine then
    return meta.lualine
  end
  return "auto"
end

-- Custom tabline
function _G.custom_tabline()
  local s = ""
  local current = vim.api.nvim_get_current_tabpage()
  local tabs = vim.api.nvim_list_tabpages()

  for i, tabnr in ipairs(tabs) do
    local is_current = tabnr == current

    -- Get tab name (use orchard if available for worktree/branch detection)
    local name
    local orchard_ok, orchard_tabline = pcall(require, "orchard.tabline")
    if orchard_ok then
      name = orchard_tabline.get_tab_name(tabnr, i)
    else
      name = vim.t[tabnr].name
      if not name then
        local cwd_ok, cwd = pcall(vim.fn.getcwd, -1, tabnr)
        name = cwd_ok and vim.fn.fnamemodify(cwd, ":t") or tostring(i)
      end
    end

    -- Bell indicator
    local bell = vim.t[tabnr].has_bell and "󰂚 " or ""

    -- Tab content
    local tab_hl = is_current and "%#TabLineSel#" or "%#TabLine#"
    s = s .. tab_hl .. " " .. i .. " " .. bell .. name .. " "

  end

  s = s .. "%#TabLineFill#"
  return s
end
vim.o.tabline = "%!v:lua.custom_tabline()"

-- Tabline highlight groups - applied after colorscheme loads
local function setup_tabline_highlights()
  local colors = _G.ui_palette()
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.panel_fill, bg = colors.accent, bold = true })
  vim.api.nvim_set_hl(0, "TabLine", { fg = colors.faint, bg = colors.panel_bg })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.panel_fill })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "tokyonight*", "ayu*" },
  callback = setup_tabline_highlights,
})

-- Auto-switch theme when macOS appearance changes
vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Switch colorscheme to match macOS appearance",
  callback = function()
    local handle = io.popen("dark-mode status")
    if not handle then return end
    local status = handle:read("*l")
    handle:close()
    local want = status == "on" and "dark" or "light"
    if vim.go.background == want then
      return
    end
    vim.cmd.colorscheme(_G.current_theme())
    if _G.setup_lualine then
      _G.setup_lualine()
    end
  end,
})

-- Terminal conveniences (I to enter insert at start of line)
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set(
      "n",
      "I",
      "i<C-a>",
      { buffer = true, noremap = true, silent = true, desc = "Enter terminal, go to start of line" }
    )
    vim.o.showmode = true
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  desc = "Disable showmode outside terminal buffers",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.o.showmode = false
    end
  end,
})

-- Loading a file into a pre-existing buffer (the [No Name] startup buffer, or
-- one created by a picker via bufadd()) skips automatic filetype detection.
-- Core detection is suppressed by did_filetype() here, so set it directly.
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    if vim.bo[args.buf].filetype == "" and vim.bo[args.buf].buftype == "" then
      local ft = vim.filetype.match({ buf = args.buf })
      if ft then
        vim.bo[args.buf].filetype = ft
      end
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Close gitsigns blame with q
vim.api.nvim_create_autocmd("FileType", {
  desc = "Close gitsigns blame with q or <leader>gb",
  pattern = "gitsigns-blame",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>gb", "<cmd>close<cr>", { buffer = true, silent = true })
  end,
})

-- Switch to normal mode when leaving terminal
vim.api.nvim_create_autocmd({ "TermLeave", "WinLeave" }, {
  desc = "Switch to normal mode when leaving terminal",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("stopinsert")
    end
  end,
})

-- Forward bell to the host terminal and mark the tab containing the calling terminal
function _G.forward_bell(pid)
  io.stdout:write("\a")
  io.stdout:flush()

  -- Find which terminal buffer owns this PID by walking up the process tree
  local function get_ppid(p)
    local handle = io.popen("ps -o ppid= -p " .. p .. " 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      return tonumber(result:match("%d+"))
    end
  end

  -- Build set of ancestor PIDs
  local ancestors = {}
  local current_pid = pid
  while current_pid and current_pid > 1 do
    ancestors[current_pid] = true
    current_pid = get_ppid(current_pid)
  end

  -- Check if this bell is from Claude Code terminal (hidden float)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      local job_pid = vim.b[buf].terminal_job_pid
      if job_pid and ancestors[job_pid] then
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname:match("claude") then
          vim.g.claude_awaiting_input = true
          return
        end
      end
    end
  end

  -- Find terminal buffer whose job PID is in our ancestor chain (for tabs)
  local current_tab = vim.api.nvim_get_current_tabpage()
  for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    if tabnr ~= current_tab then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
          local job_pid = vim.b[buf].terminal_job_pid
          if job_pid and ancestors[job_pid] then
            vim.t[tabnr].has_bell = true
            vim.cmd("redrawtabline")
            return
          end
        end
      end
    end
  end
  vim.cmd("redrawtabline")
end

vim.api.nvim_create_autocmd("TermRequest", {
  desc = "Forward terminal bells to the host terminal and mark vim tabs",
  callback = function(args)
    if args.data == "\x07" then
      local bufnr = args.buf
      local pid = vim.b[bufnr].terminal_job_pid
      _G.forward_bell(pid)
    end
  end,
})

-- Clear bell indicator when entering a tab
vim.api.nvim_create_autocmd("TabEnter", {
  desc = "Clear bell indicator on tab enter",
  callback = function()
    vim.t.has_bell = nil
  end,
})

-- Clear Claude indicator when entering Claude's terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Clear Claude awaiting indicator when entering Claude buffer",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("claude") and vim.bo.buftype == "terminal" then
      vim.g.claude_awaiting_input = nil
    end
  end,
})

-- Test command: run `:TestBell` in a terminal buffer to test notifications
vim.api.nvim_create_user_command("TestBell", function()
  local chan = vim.b.terminal_job_id
  if chan then
    vim.api.nvim_chan_send(chan, "printf '\\a'\n")
  else
    vim.notify("Not in a terminal buffer", vim.log.levels.WARN)
  end
end, {})
