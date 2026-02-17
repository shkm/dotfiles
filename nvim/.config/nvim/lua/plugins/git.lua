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
    config = function(_, opts)
      require("codediff").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "codediff-history", "codediff-explorer" },
        callback = function(args)
          local function scroll_diff(key)
            local lifecycle = require("codediff.ui.lifecycle")
            local tabpage = vim.api.nvim_get_current_tabpage()
            local session = lifecycle.get_session(tabpage)
            if not session or not session.modified_win then return end
            local win = session.modified_win
            if not vim.api.nvim_win_is_valid(win) then return end
            vim.fn.win_execute(win, 'execute "normal! ' .. key .. '"')
          end
          vim.keymap.set("n", "J", function() scroll_diff("\\<C-d>") end, { buffer = args.buf, desc = "Scroll diff down" })
          vim.keymap.set("n", "K", function() scroll_diff("\\<C-u>") end, { buffer = args.buf, desc = "Scroll diff up" })

          if vim.bo[args.buf].filetype == "codediff-history" then
            local function jump_commit(direction)
              local lifecycle = require("codediff.ui.lifecycle")
              local history_render = require("codediff.ui.history.render")
              local panel = lifecycle.get_explorer(vim.api.nvim_get_current_tabpage())
              if not panel or not panel.tree then return end
              local commits = history_render.get_all_commits(panel.tree)
              if #commits == 0 then return end
              local cur = vim.api.nvim_win_get_cursor(0)[1]
              if direction == 1 then
                for _, c in ipairs(commits) do
                  if c.node._line and c.node._line > cur then
                    vim.api.nvim_win_set_cursor(0, { c.node._line, 0 })
                    return
                  end
                end
                vim.api.nvim_win_set_cursor(0, { commits[1].node._line or 1, 0 })
              else
                for i = #commits, 1, -1 do
                  if commits[i].node._line and commits[i].node._line < cur then
                    vim.api.nvim_win_set_cursor(0, { commits[i].node._line, 0 })
                    return
                  end
                end
                vim.api.nvim_win_set_cursor(0, { commits[#commits].node._line or 1, 0 })
              end
            end
            vim.keymap.set("n", "]C", function() jump_commit(1) end, { buffer = args.buf, desc = "Next commit" })
            vim.keymap.set("n", "[C", function() jump_commit(-1) end, { buffer = args.buf, desc = "Previous commit" })
          end
        end,
      })
    end,
    opts = {
      diff = {
        cycle_next_hunk = false,
      },
      keymaps = {
        explorer = {
          hover = false,
        },
      },
    },
    keys = {
      { "<leader>gh", "<cmd>CodeDiff history<cr>", desc = "Git history" },
    },
  },

  -- Octo - GitHub issues & PRs
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {},
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
