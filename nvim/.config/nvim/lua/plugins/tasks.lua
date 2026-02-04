return {
  -- TODO: switch back to stevearc/overseer.nvim after PR #494 is merged
  "shkm/overseer.nvim",
  branch = "fix-mix-provider-callback",
  keys = {
    { "<leader>e", nil, desc = "Execute" },
    { "<leader>er", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>eo", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
  },
  opts = {
    disable_template_modules = { "overseer.template.mix" },
    actions = {
      ["open url"] = {
        desc = "Open the task URL in browser",
        condition = function(task)
          return task.metadata and task.metadata.url
        end,
        run = function(task)
          vim.ui.open(task.metadata.url)
        end,
      },
    },
    task_list = {
      keymaps = {
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["J"] = "keymap.scroll_output_down",
        ["K"] = "keymap.scroll_output_up",
        ["gx"] = { "keymap.run_action", opts = { action = "open url" }, desc = "Open task URL" },
        ["r"] = { "keymap.run_action", opts = { action = "restart" }, desc = "Restart task" },
      },
      render = function(task)
        local STATUS = {
          RUNNING = { icon = "󰐊", hl = "DiagnosticInfo" },
          SUCCESS = { icon = "󰄬", hl = "DiagnosticOk" },
          FAILURE = { icon = "󰅖", hl = "DiagnosticError" },
          CANCELED = { icon = "󰜺", hl = "DiagnosticWarn" },
          PENDING = { icon = "󰔟", hl = "Comment" },
        }
        local s = STATUS[task.status] or { icon = "?", hl = "Normal" }
        return {
          { { s.icon .. " ", s.hl }, { task.name, "Normal" } },
        }
      end,
    },
  },
}
