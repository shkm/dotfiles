return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
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
          local function get_commit_at_cursor()
            local lifecycle = require("codediff.ui.lifecycle")
            local panel = lifecycle.get_explorer(vim.api.nvim_get_current_tabpage())
            if not panel or not panel.tree then return nil end
            local node = panel.tree:get_node()
            if not node or not node.data then return nil end
            -- Walk up to commit node if on a file/directory child
            while node and node.data and node.data.type ~= "commit" do
              node = panel.tree:get_node(node:get_parent_id())
            end
            if node and node.data and node.data.type == "commit" then
              return node.data
            end
            return nil
          end

          vim.keymap.set("n", "J", function() scroll_diff("\\<C-d>") end, { buffer = args.buf, desc = "Scroll diff down" })
          vim.keymap.set("n", "K", function() scroll_diff("\\<C-u>") end, { buffer = args.buf, desc = "Scroll diff up" })

          vim.keymap.set("n", "gK", function()
            local commit = get_commit_at_cursor()
            if not commit then return end
            local result = vim.fn.systemlist({ "git", "-C", commit.git_root, "show", "--no-patch", "--format=%B", commit.hash })
            vim.lsp.util.open_floating_preview(result, "", { border = "rounded", focus_id = "commit_msg" })
          end, { buffer = args.buf, desc = "Show full commit message" })

          vim.keymap.set("n", "gx", function()
            local commit = get_commit_at_cursor()
            if not commit then return end
            vim.fn.jobstart({ "gh", "browse", commit.hash }, { cwd = commit.git_root, detach = true })
          end, { buffer = args.buf, desc = "Open commit on GitHub" })

          vim.keymap.set("n", "o", function()
            local lifecycle = require("codediff.ui.lifecycle")
            local panel = lifecycle.get_explorer(vim.api.nvim_get_current_tabpage())
            if not panel or not panel.tree then return end
            local node = panel.tree:get_node()
            if not node or not node.data then return end

            if node.data.type == "file" then
              local file_path = node.data.git_root .. "/" .. node.data.path
              vim.cmd("tabclose")
              vim.schedule(function()
                vim.cmd("CodeDiff history " .. vim.fn.fnameescape(file_path))
              end)
            else
              local commit = get_commit_at_cursor()
              if not commit then return end
              local range = commit.hash .. "~1.." .. commit.hash
              vim.cmd("tabclose")
              vim.schedule(function()
                vim.cmd("CodeDiff history " .. range)
              end)
            end
          end, { buffer = args.buf, desc = "Toggle between file/commit history" })

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
        jump_to_first_change = true,
      },
      keymaps = {
        explorer = {
          hover = false,
        },
      },
    },
    keys = {
      { "<leader>gh", "<cmd>CodeDiff history<cr>", desc = "Git history" },
      { "<leader>gf", "<cmd>CodeDiff history %<cr>", desc = "Git file history" },
    },
  },

  -- Octo - GitHub issues & PRs
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {},
  },

  -- Orchard - worktree manager
  {
    dir = vim.fn.stdpath("config") .. "/plugins/orchard.nvim",
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
