return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function(_, opts)
    require("claude-code").setup(opts)
    vim.api.nvim_create_autocmd("TermOpen", {
      callback = function(ev)
        vim.schedule(function()
          local name = vim.api.nvim_buf_get_name(ev.buf)
          if name:match("claude%-code") then
            vim.keymap.set("n", "q", "<cmd>ClaudeCode<cr>", { buffer = ev.buf, desc = "Hide Claude Code" })
          end
        end)
      end,
    })
  end,
  opts = {
    window = {
      position = "float",
      float_opts = {
        width = 0.9,
        height = 0.9,
      },
      enter_insert = false,
      start_in_normal_mode = true,
    },
    keymaps = {
      toggle = {
        normal = "<C-'>",
        terminal = "<C-'>",
        variants = {},
      },
    },
  },
  keys = {
    { "<leader>a", nil, desc = "AI" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
    { "<leader>ar", "<cmd>ClaudeCodeResume<cr>", desc = "Resume conversation" },
  },
}
