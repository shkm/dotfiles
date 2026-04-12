local M = {}

M.opts = {
  daily_format = "%Y-%m-%d",
}

-- Notes cache, invalidated on BufWritePost in notes dir
local notes_cache = nil

local function is_daily_note(path)
  return path:find(M.opts.daily_dir, 1, true) == 1
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  if not M.opts.dir then error("noteworthy: opts.dir is required") end
  if not M.opts.daily_dir then error("noteworthy: opts.daily_dir is required") end

  M.opts.dir = vim.fn.resolve(vim.fn.expand(M.opts.dir))
  M.opts.daily_dir = vim.fn.resolve(vim.fn.expand(M.opts.daily_dir))

  vim.api.nvim_create_user_command("NoteworthyFind", M.find, {})
  vim.api.nvim_create_user_command("NoteworthyFindDaily", M.find_daily, {})
  vim.api.nvim_create_user_command("NoteworthySearch", M.search, {})
  vim.api.nvim_create_user_command("NoteworthyNew", function()
    M.create(vim.fn.input("Title: "))
  end, {})
  vim.api.nvim_create_user_command("NoteworthyToday", M.today, {})

  -- Invalidate cache when a note is saved
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.md",
    callback = function(ev)
      local path = vim.fn.resolve(vim.api.nvim_buf_get_name(ev.buf))
      if path:find(M.opts.dir, 1, true) then
        notes_cache = nil
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(ev)
      if not M.is_note(ev.buf) then return end
      if M.opts.on_attach then
        M.opts.on_attach(ev.buf)
      end
    end,
  })
end

--- Scan all .md files and extract the first `# Title` line.
--- Returns a cached list of { title, file, rel }.
function M.get_notes()
  if notes_cache then return notes_cache end

  local notes = {}
  local dir = M.opts.dir

  local function scan(path)
    for name, type in vim.fs.dir(path) do
      local full = path .. "/" .. name
      if type == "directory" then
        scan(full)
      elseif name:match("%.md$") then
        local f = io.open(full, "r")
        if f then
          local title
          for line in f:lines() do
            local heading = line:match("^#%s+(.+)")
            if heading then
              title = heading
              break
            end
          end
          f:close()
          local rel = full:sub(#dir + 2):gsub("%.md$", "")
          table.insert(notes, {
            title = title or vim.fn.fnamemodify(name, ":r"),
            file = full,
            rel = rel,
          })
        end
      end
    end
  end

  scan(dir)
  notes_cache = notes
  return notes
end

--- Parse a [[link]] or [[link|alias]] under the cursor.
--- Returns { target = "...", alias = "..." or nil } or nil.
function M.link_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local s, e, content = nil, 0, nil
  while true do
    s, e, content = line:find("%[%[(.-)%]%]", e + 1)
    if not s then break end
    if col >= s and col <= e then
      local target, alias = content:match("^(.-)|(.*)")
      return { target = target or content, alias = alias }
    end
  end
end

--- Resolve a link target to a note.
--- Matches by: title, relative path, or filename stem. Prefers exact rel path match.
function M.resolve_link(target)
  local notes = M.get_notes()
  local matches = {}

  for _, note in ipairs(notes) do
    if note.title == target or note.rel == target or note.rel:match("[^/]+$") == target then
      table.insert(matches, note)
    end
  end

  if #matches == 1 then
    return matches[1]
  elseif #matches > 1 then
    for _, note in ipairs(matches) do
      if note.rel == target then return note end
    end
    return matches[1]
  end
end

--- Follow a [[wiki link]] under the cursor.
function M.follow_link()
  local link = M.link_under_cursor()
  if link then
    local note = M.resolve_link(link.target)
    if note then
      vim.cmd("edit " .. vim.fn.fnameescape(note.file))
    else
      M.create(link.target)
    end
  else
    vim.lsp.buf.definition()
  end
end

--- Show a floating preview of the [[wiki link]] under the cursor.
function M.hover()
  local link = M.link_under_cursor()
  if not link then
    return vim.lsp.buf.hover()
  end

  local note = M.resolve_link(link.target)
  if not note then
    vim.notify("Note not found: " .. link.target, vim.log.levels.WARN)
    return
  end

  local lines = {}
  local f = io.open(note.file, "r")
  if f then
    local count = 0
    for line in f:lines() do
      count = count + 1
      if count > 20 then
        table.insert(lines, "...")
        break
      end
      table.insert(lines, line)
    end
    f:close()
  end

  vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "rounded",
    max_width = 80,
    max_height = 20,
  })
end

--- Check if a buffer belongs to the notes directory.
function M.is_note(buf)
  local path = vim.fn.resolve(vim.api.nvim_buf_get_name(buf))
  return path:find(M.opts.dir, 1, true) ~= nil
end

--- Slugify a title into a filename-safe string.
function M.slugify(title)
  return title:lower():gsub("[^%w%s-]", ""):gsub("%s+", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
end

--- Open the snacks picker with note titles.
function M.find()
  local notes = vim.tbl_filter(function(note)
    return not is_daily_note(note.file)
  end, M.get_notes())
  local dir = M.opts.dir

  local items = {}
  for _, note in ipairs(notes) do
    table.insert(items, {
      text = note.title .. " " .. note.rel,
      title = note.title,
      file = note.file,
    })
  end

  local ns = vim.api.nvim_create_namespace("noteworthy_create_hint")
  local closed = false

  Snacks.picker({
    title = "Notes",
    items = items,
    format = function(item)
      local rel = item.file:sub(#dir + 2)
      return {
        { item.title },
        { "  " },
        { rel, "Comment" },
      }
    end,
    on_show = function(picker)
      local timer = vim.uv.new_timer()
      timer:start(100, 100, vim.schedule_wrap(function()
        if closed then
          if not timer:is_closing() then
            timer:stop()
            timer:close()
          end
          return
        end
        local list_buf = picker.list and picker.list.win and picker.list.win.buf
        if not list_buf or not vim.api.nvim_buf_is_valid(list_buf) then return end
        vim.api.nvim_buf_clear_namespace(list_buf, ns, 0, -1)
        local pattern = picker.input.filter.pattern
        if pattern ~= "" and not picker:current() then
          vim.api.nvim_buf_set_extmark(list_buf, ns, 0, 0, {
            virt_text = {
              { 'Create "' .. pattern .. '" (Enter or C-x)', "DiagnosticHint" },
            },
            virt_text_pos = "overlay",
          })
        end
      end))
    end,
    on_close = function()
      closed = true
    end,
    confirm = function(picker, item)
      local query = picker.input.filter.pattern
      picker:close()
      if item then
        vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      elseif query and query ~= "" then
        M.create(query)
      end
    end,
    actions = {
      create = function(picker)
        local query = picker.input.filter.pattern
        picker:close()
        if query and query ~= "" then
          M.create(query)
        end
      end,
      refresh = function(picker)
        notes_cache = nil
        local fresh = vim.tbl_filter(function(note)
          return not is_daily_note(note.file)
        end, M.get_notes())
        local new_items = {}
        for _, note in ipairs(fresh) do
          table.insert(new_items, {
            text = note.title .. " " .. note.rel,
            title = note.title,
            file = note.file,
          })
        end
        picker.finder.items = new_items
        picker:find({ refresh = true })
      end,
    },
    win = {
      input = {
        keys = {
          ["<C-x>"] = { "create", mode = { "n", "i" }, desc = "Create note" },
          ["<C-r>"] = { "refresh", mode = { "n", "i" }, desc = "Refresh notes" },
        },
      },
      list = {
        keys = {
          ["<C-x>"] = { "create", mode = { "n" }, desc = "Create note" },
          ["<C-r>"] = { "refresh", mode = { "n" }, desc = "Refresh notes" },
        },
      },
    },
  })
end

--- Open the snacks picker with daily notes only.
function M.find_daily()
  local notes = vim.tbl_filter(function(note)
    return is_daily_note(note.file)
  end, M.get_notes())
  local dir = M.opts.daily_dir

  local items = {}
  for _, note in ipairs(notes) do
    table.insert(items, {
      text = note.title .. " " .. note.rel,
      title = note.title,
      file = note.file,
    })
  end

  Snacks.picker({
    title = "Daily Notes",
    items = items,
    format = function(item)
      local rel = item.file:sub(#dir + 2)
      return {
        { item.title },
        { "  " },
        { rel, "Comment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      end
    end,
  })
end

--- Search note contents in the notes directory.
function M.search()
  Snacks.picker.grep({
    title = "Search Notes",
    cwd = M.opts.dir,
  })
end

--- Create a new note with the given title.
function M.create(title)
  if not title or title == "" then return end
  local slug = M.slugify(title)
  if slug == "" then
    vim.notify("Invalid note title: " .. title, vim.log.levels.WARN)
    return
  end
  local path = M.opts.dir .. "/" .. slug .. ".md"
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  if vim.fn.filereadable(path) == 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# " .. title, "" })
  end
  notes_cache = nil
end

--- Open today's daily note.
function M.today()
  local daily_dir = M.opts.daily_dir
  vim.fn.mkdir(daily_dir, "p")
  local date = os.date(M.opts.daily_format)
  local path = daily_dir .. "/" .. date .. ".md"
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  if vim.fn.filereadable(path) == 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# " .. date, "" })
  end
  notes_cache = nil
end

return M
