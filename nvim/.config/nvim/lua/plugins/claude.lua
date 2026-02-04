return {
  -- TODO: Switch back to greggh/claude-code.nvim when PR #106 is merged
  "shkm/claude-code.nvim",
  branch = "fix/terminal-exit-cleanup",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    window = {
      position = "float",
      float_opts = {
        width = 0.9,
        height = 0.9,
      },
      enter_insert = false,
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
