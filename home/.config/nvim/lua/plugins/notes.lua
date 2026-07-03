return {
  {
    dir = "~/repos/obsidivim",
    event = "BufReadPre",
    keys = {
      { "<leader>nf", "<cmd>ObsidivimFind<cr>", desc = "Find note" },
      { "<leader>nd", "<cmd>ObsidivimFindDaily<cr>", desc = "Find daily notes" },
      { "<leader>n/", "<cmd>ObsidivimSearch<cr>", desc = "Search notes" },
      { "<leader>nn", "<cmd>ObsidivimNew<cr>", desc = "New note" },
      { "<leader>nb", "<cmd>ObsidivimBacklinks<cr>", desc = "Backlinks" },
      { "<leader>nt", "<cmd>ObsidivimToday<cr>", desc = "Daily note (today)" },
      { "<leader>ny", "<cmd>ObsidivimYesterday<cr>", desc = "Daily note (yesterday)" },
    },
    opts = {
      dir = "~/notes",
      daily_dir = "~/notes/daily",
      daily_path_format = "%Y/%m/%Y-%m-%d",
      daily_title_format = "%A, %-d %B %Y",
      auto_save = true,
      on_attach = function(buf)
        local ov = require("obsidivim")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "K", ov.hover, "Preview wiki link")
        map("n", "gf", ov.follow_link, "Follow wiki link")
        map("n", "<C-]>", ov.follow_link, "Follow wiki link")
      end,
    },
  },
}
