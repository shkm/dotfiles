return {
  {
    "roodolv/markdown-toggle.nvim",
    ft = "markdown",
    opts = {
      list_before_box = true,
    },
    config = function(_, opts)
      local mt = require("markdown-toggle")
      mt.setup(opts)

      local function transform_checkbox(line)
        if line:match("^%s*[%-+*]%s+%[ %]") then
          return (line:gsub("%[ %]", "[x]", 1))
        end
        if line:match("^%s*[%-+*]%s+%[.%]") then
          return (line:gsub("%[.%]", "[ ]", 1))
        end
        if line:match("^%s*[%-+*]%s") then
          return (line:gsub("^(%s*[%-+*])%s", "%1 [ ] "))
        end
        local ws, text = line:match("^(%s*)(.*)")
        return (ws or "") .. "- [ ] " .. (text or "")
      end

      local function transform_bullet(line)
        if line:match("^%s*[%-+*]%s+%[.%]%s") then
          return (line:gsub("^(%s*)[%-+*]%s+%[.%]%s", "%1"))
        end
        if line:match("^%s*[%-+*]%s") then
          return (line:gsub("^(%s*)[%-+*]%s", "%1"))
        end
        local ws, text = line:match("^(%s*)(.*)")
        return (ws or "") .. "- " .. (text or "")
      end

      local function apply_to_lines(transform)
        local mode = vim.fn.mode()
        if mode == "n" then
          vim.api.nvim_set_current_line(transform(vim.api.nvim_get_current_line()))
        else
          local sl = vim.fn.line("'<") - 1
          local el = vim.fn.line("'>")
          local lines = vim.api.nvim_buf_get_lines(0, sl, el, true)
          for i, line in ipairs(lines) do
            lines[i] = transform(line)
          end
          vim.api.nvim_buf_set_lines(0, sl, el, true, lines)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("n", "<space>", function() apply_to_lines(transform_checkbox) end, "Toggle checkbox")
          map("v", "<space>", function() apply_to_lines(transform_checkbox) end, "Toggle checkbox")
          map("n", "g-", function() apply_to_lines(transform_bullet) end, "Toggle bullet")
          map("v", "g-", function() apply_to_lines(transform_bullet) end, "Toggle bullet")
          map("n", "O", mt.autolist_up, "Auto list above")
          map("n", "o", mt.autolist_down, "Auto list below")
          map("i", "<CR>", mt.autolist_cr, "Auto list continue")

          -- Markdown surrounds via mini.surround
          vim.b[ev.buf].minisurround_config = {
            custom_surroundings = {
              b = {
                input = { "%*%*().-()%*%*" },
                output = { left = "**", right = "**" },
              },
              i = {
                input = { "%*().-()%*" },
                output = { left = "*", right = "*" },
              },
              s = {
                input = { "~~().-()~~" },
                output = { left = "~~", right = "~~" },
              },
              l = {
                input = { "%[().-()%]%(.-%)" },
                output = function()
                  local url = MiniSurround.user_input("URL")
                  if not url then return nil end
                  return { left = "[", right = "](" .. url .. ")" }
                end,
              },
              C = {
                input = { "```%w*\n().-()```" },
                output = { left = "```\n", right = "\n```" },
              },
            },
          }
        end,
      })
    end,
  },
}
