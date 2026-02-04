return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function toggle_blame()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "gitsigns-blame" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
          gs.blame()
        end
        vim.keymap.set("n", "<leader>gb", toggle_blame, { buffer = bufnr, desc = "Git blame" })
        vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
        vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Previous hunk" })
      end,
    },
  },

  -- CodeDiff - VSCode-style diff view
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  },

  -- Orchard - worktree manager (local dev)
  {
    dir = "~/repos/orchard.nvim",
    dependencies = { "esmuellert/codediff.nvim" },
    event = "VeryLazy",
    cmd = "Orchard",
    opts = {},
    keys = {
      { "<leader>w", nil, desc = "Worktree" },
      { "<leader>wc", "<cmd>Orchard create<cr>", desc = "Create worktree" },
      { "<leader>wf", "<cmd>Orchard pick<cr>", desc = "Find worktree" },
      { "<leader>fw", "<cmd>Orchard pick<cr>", desc = "Find worktree" },
      { "<leader>wm", "<cmd>Orchard merge<cr>", desc = "Merge to main" },
      { "<leader>wd", "<cmd>Orchard diff<cr>", desc = "Diff worktree" },
      { "<leader>wD", "<cmd>Orchard delete<cr>", desc = "Delete worktree" },
    },
  },
}
