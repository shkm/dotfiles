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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("n", "<space>", mt.checkbox, "Toggle checkbox")
          map("v", "<space>", mt.checkbox, "Toggle checkbox")
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
