return {
  {
    url = "https://tangled.org/@jamie.schembri.me/obsidivim",
    version = "*",
    -- For testing the local working tree instead:
    -- dir = "~/repos/obsidivim",
    event = "BufReadPre",
    keys = {
      -- find
      { "<leader>nf", "<cmd>ObsidivimFind<cr>", desc = "Find note" },
      { "<leader>n/", "<cmd>ObsidivimSearch<cr>", desc = "Search notes" },
      { "<leader>nb", "<cmd>ObsidivimBacklinks<cr>", desc = "Backlinks" },
      { "<leader>n#", "<cmd>ObsidivimTags<cr>", desc = "Tags" },
      -- write
      { "<leader>nn", "<cmd>ObsidivimNew<cr>", desc = "New note" },
      { "<leader>nR", "<cmd>ObsidivimRename<cr>", desc = "Rename note" },
      { "<leader>ns", "<cmd>ObsidivimSnippet<cr>", desc = "Insert snippet" },
      -- dailies
      { "<leader>nd", "<cmd>ObsidivimFindDaily<cr>", desc = "Find daily notes" },
      { "<leader>nt", "<cmd>ObsidivimToday<cr>", desc = "Daily note (today)" },
      { "<leader>ny", "<cmd>ObsidivimYesterday<cr>", desc = "Daily note (yesterday)" },
      -- ui
      { "<leader>np", "<cmd>ObsidivimPalette<cr>", desc = "Command palette" },
      { "<leader>nP", "<cmd>ObsidivimInfoPanel<cr>", desc = "Toggle info panel" },
    },
    opts = {
      dir = "~/notes",
      daily_dir = "~/notes/daily",
      snippets_dir = "~/notes/.snippets",
      daily_path_format = "%Y/%m/%Y-%m-%d",
      daily_title_format = "%A, %-d %B %Y",
      auto_save = true,
      info_panel = { enabled = true },
      highlight = { external_icon = " " }, -- nf-oct-link-external
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
