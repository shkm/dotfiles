return {
  {
    dir = vim.fn.stdpath("config") .. "/plugins/noteworthy.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>nf", "<cmd>NoteworthyFind<cr>", desc = "Find note" },
      { "<leader>nn", "<cmd>NoteworthyNew<cr>", desc = "New note" },
      { "<leader>nt", "<cmd>NoteworthyToday<cr>", desc = "Daily note (today)" },
    },
    opts = {
      dir = "~/notes",
      daily_dir = "~/notes/daily",
      on_attach = function(buf)
        local nw = require("noteworthy")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "K", nw.hover, "Preview wiki link")
        map("n", "gf", nw.follow_link, "Follow wiki link")
        map("n", "<C-]>", nw.follow_link, "Follow wiki link")
      end,
    },
  },
}
