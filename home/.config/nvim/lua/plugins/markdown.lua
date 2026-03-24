return {
  {
    dir = vim.fn.stdpath("config") .. "/plugins/mdplus.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "markdown",
    keys = {
      { "<C-k>", function() require("mdplus").insert_link() end, mode = "i", ft = "markdown", desc = "Insert link" },
      { "gK", function() require("mdplus").insert_link() end, ft = "markdown", desc = "Edit link" },
      { "gK", function() require("mdplus").insert_link({ visual = true }) end, mode = "v", ft = "markdown", desc = "Link selection" },
      { "<Tab>", function() require("mdplus").list_indent(">>", "<Tab>")() end, mode = "i", ft = "markdown", desc = "Indent list item" },
      { "<S-Tab>", function() require("mdplus").list_indent("<<", "<S-Tab>")() end, mode = "i", ft = "markdown", desc = "Outdent list item" },
    },
  },
  {
    "roodolv/markdown-toggle.nvim",
    ft = "markdown",
    opts = {
      list_before_box = true,
    },
    config = function(_, opts)
      local mt = require("markdown-toggle")
      mt.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("n", "g-", mt.list, "Toggle bullet")
          map("n", "g.", function()
            local line = vim.api.nvim_get_current_line()
            if line:match("^%s*[%-+*]%s+%[x%]") then
              vim.api.nvim_set_current_line((line:gsub("%[x%]", "[ ]", 1)))
            elseif line:match("^%s*[%-+*]%s+%[ %]") then
              vim.api.nvim_set_current_line((line:gsub("%[ %]", "[x]", 1)))
            elseif line:match("^%s*[%-+*]%s") then
              vim.api.nvim_set_current_line((line:gsub("^(%s*[%-+*]%s)", "%1[ ] ", 1)))
            else
              local ws, text = line:match("^(%s*)(.*)")
              vim.api.nvim_set_current_line((ws or "") .. "- [ ] " .. (text or ""))
            end
          end, "Toggle checkbox")
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
