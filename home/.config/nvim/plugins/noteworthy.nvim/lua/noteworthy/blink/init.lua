local M = {}

function M.new(opts, config)
  local self = setmetatable({}, { __index = M })
  return self
end

function M:enabled()
  return vim.bo.filetype:match("^markdown") ~= nil
end

function M:get_trigger_characters()
  return { "[" }
end

function M:get_completions(context, callback)
  local line = context.line
  local col = context.cursor[2]

  -- Find the [[ before cursor
  local before = line:sub(1, col)
  local link_start = before:match(".*()%[%[")
  if not link_start then
    return callback()
  end

  local noteworthy = require("noteworthy")
  local notes = noteworthy.get_notes()

  -- Detect duplicate titles to show paths for disambiguation
  local title_count = {}
  for _, note in ipairs(notes) do
    title_count[note.title] = (title_count[note.title] or 0) + 1
  end

  local items = {}
  for _, note in ipairs(notes) do
    local label = note.title
    local detail = nil
    if title_count[note.title] > 1 then
      detail = note.rel
    end
    table.insert(items, {
      label = label,
      detail = detail,
      kind = vim.lsp.protocol.CompletionItemKind.Reference,
      -- Use rel path for duplicates so the link is unambiguous
      insertText = (title_count[note.title] > 1 and note.rel or note.title) .. "]]",
      filterText = "[[" .. note.title .. " " .. note.rel,
      data = { file = note.file },
    })
  end

  callback({
    context = context,
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
  })
end

function M:resolve(item, callback)
  local file = item.data and item.data.file
  if not file then return callback(item) end

  local f = io.open(file, "r")
  if not f then return callback(item) end

  local lines = {}
  local count = 0
  for line in f:lines() do
    count = count + 1
    if count > 30 then
      lines[#lines + 1] = "..."
      break
    end
    lines[#lines + 1] = line
  end
  f:close()

  item.documentation = {
    kind = vim.lsp.protocol.MarkupKind.Markdown,
    value = table.concat(lines, "\n"),
  }
  callback(item)
end

return M
