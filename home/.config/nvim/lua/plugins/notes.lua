return {
  {
    dir = vim.fn.stdpath("config") .. "/plugins/noteworthy.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>nf", "<cmd>NoteworthyFind<cr>", desc = "Find note" },
      { "<leader>nn", "<cmd>NoteworthyNew<cr>", desc = "New note" },
      { "<leader>nt", "<cmd>NoteworthyToday<cr>", desc = "Daily note (today)" },
      { "gf", function() require("noteworthy").follow_link() end, ft = "markdown.noteworthy", desc = "Follow wiki link" },
      { "<C-]>", function() require("noteworthy").follow_link() end, ft = "markdown.noteworthy", desc = "Follow wiki link" },
    },
    opts = {
      dir = "~/notes",
      daily_dir = "~/notes/daily",
    },
  },
}
