local M = {}

--- Check if cursor is inside a list item via treesitter.
function M.in_list()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == "list_item" then return true end
    node = node:parent()
  end
  return false
end

--- Returns a function that indents/outdents if in a list, otherwise falls through.
function M.list_indent(key, fallback)
  return function()
    if M.in_list() then
      vim.cmd("normal! " .. key)
      vim.cmd("startinsert!")
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(fallback, true, false, true), "n", false)
    end
  end
end

-- Link insertion/editing

local function is_url(str)
  return str:match("^https?://") or str:match("^www%.")
end

local function prefill_from(str, col_start, col_end)
  if is_url(str) then
    return str, "", col_start, col_end
  else
    return "", str, col_start, col_end
  end
end

local function find_link_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local search_start = 1
  while true do
    local s, e, text, url = line:find("%[([^%]]*)%]%(([^%)]*)%)", search_start)
    if not s then break end
    if col >= s and col <= e then
      return url, text, s, e
    end
    search_start = e + 1
  end
end

local function find_word_at_cursor()
  local word = vim.fn.expand("<cWORD>")
  if not word or word == "" then return nil end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local s = line:find(word, math.max(1, col - #word), true)
  if not s then return nil end

  if not is_url(word) then
    word = vim.fn.expand("<cword>")
    if word == "" then return nil end
    s = line:find(word, math.max(1, col - #word), true)
    if not s then return nil end
  end

  return word, s, s + #word - 1
end

local function get_visual_selection()
  vim.cmd('noautocmd normal! "vy')
  local text = vim.fn.getreg("v")
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  if s[2] ~= e[2] then return nil end
  return text, s[3], e[3]
end

function M.insert_link(opts)
  opts = opts or {}
  local Input = require("nui.input")
  local Layout = require("nui.layout")

  local default_url, default_text = "", ""
  local replace_start, replace_end

  if opts.visual then
    local sel, cs, ce = get_visual_selection()
    if sel then
      default_url, default_text, replace_start, replace_end = prefill_from(sel, cs, ce)
    end
  else
    local url, text, ls, le = find_link_at_cursor()
    if url then
      default_url, default_text, replace_start, replace_end = url, text, ls, le
    else
      local word, ws, we = find_word_at_cursor()
      if word then
        default_url, default_text, replace_start, replace_end = prefill_from(word, ws, we)
      end
    end
  end

  local url_value, text_value = default_url, default_text
  local layout, url_input, text_input

  local closed = false
  local function close()
    if closed then return end
    closed = true
    vim.schedule(function()
      url_input:unmount()
      text_input:unmount()
    end)
  end

  local function submit()
    if url_value ~= "" and text_value ~= "" then
      close()
      vim.schedule(function()
        local link = "[" .. text_value .. "](" .. url_value .. ")"
        if replace_start then
          local line = vim.api.nvim_get_current_line()
          vim.api.nvim_set_current_line(line:sub(1, replace_start - 1) .. link .. line:sub(replace_end + 1))
        else
          vim.api.nvim_put({ link }, "c", false, true)
        end
      end)
    end
  end

  local title = replace_start and " Edit Link " or " Insert Link "

  url_input = Input({
    border = {
      style = "rounded",
      text = { top = title, top_align = "center" },
    },
    win_options = { winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
  }, {
    prompt = " URL:  ",
    default_value = default_url,
    on_change = function(v) url_value = v end,
    on_submit = function(v)
      url_value = v
      vim.api.nvim_set_current_win(text_input.winid)
      vim.cmd("startinsert!")
    end,
    on_close = close,
  })

  text_input = Input({
    border = {
      style = "rounded",
    },
    win_options = { winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
  }, {
    prompt = " Text: ",
    default_value = default_text,
    on_change = function(v) text_value = v end,
    on_submit = function(v)
      text_value = v
      submit()
    end,
    on_close = close,
  })

  layout = Layout(
    {
      position = "50%",
      size = { width = 60, height = 6 },
    },
    Layout.Box({
      Layout.Box(url_input, { size = 2 }),
      Layout.Box(text_input, { size = 3 }),
    }, { dir = "col" })
  )

  local focus_text = default_url ~= "" and default_text == ""

  layout:mount()
  vim.schedule(function()
    vim.api.nvim_set_current_win(focus_text and text_input.winid or url_input.winid)
    vim.cmd("startinsert!")
  end)

  for _, input in ipairs({ url_input, text_input }) do
    input:map("i", "<Esc>", close, { noremap = true })
    input:map("i", "<Tab>", function()
      local target = vim.api.nvim_get_current_win() == url_input.winid
          and text_input or url_input
      vim.api.nvim_set_current_win(target.winid)
      vim.cmd("startinsert!")
    end, { noremap = true })
  end
end

return M
