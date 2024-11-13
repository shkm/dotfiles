local neotreeState = function()
  local manager = require("neo-tree.sources.manager")
  local renderer = require("neo-tree.ui.renderer")

  local state = manager.get_state("filesystem")
  local window_exists = renderer.window_exists(state)

  if window_exists then
    if vim.bo.filetype == "neo-tree" then
      return "focused"
    else
      return "open"
    end
  else
    return "closed"
  end
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      commands = {
        -- If item is a file it will close neotree after opening it.
        open_and_close_neotree = function(state)
          require("neo-tree.sources.filesystem.commands").open(state)

          local tree = state.tree
          local success, node = pcall(tree.get_node, tree)

          if not success then
            return
          end

          if node.type == "file" then
            require("neo-tree.command").execute({ action = "close" })
          end
        end,
      },
      window = {
        mappings = {
          ["<CR>"] = "open_and_close_neotree",
          ["<S-CR>"] = "open",
        },
      },
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        local state = neotreeState()
        local command = require("neo-tree.command")

        if state == "focused" then
          command.execute({ action = "close" })
        elseif state == "open" then
          command.execute({ action = "focus" })
        else
          command.execute({ toggle = true, dir = LazyVim.root() })
        end
      end,
      "<leader>fe",
      desc = "NeoTree",
    },
    {
      "<leader>fE",
      function()
        local state = neotreeState()
        local command = require("neo-tree.command")

        if state == "focused" then
          command.execute({ action = "close" })
        elseif state == "open" then
          command.execute({ action = "focus" })
        else
          command.execute({ toggle = true, reveal = true, reveal_force_cwd = true })
        end
      end,
      "<leader>fe",
      desc = "NeoTree (reveal)",
    },
    { "-", "<leader>fe", remap = true },
    { "_", "<leader>fE", remap = true },
  },
}
