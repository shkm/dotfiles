return {
  -- Smart splits - seamless navigation with Kitty
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    build = "./kitty/install-kittens.bash",
    opts = {
      at_edge = "stop",
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
      local function nav_with_stopinsert(direction)
        return function()
          if vim.bo.buftype == "terminal" then
            vim.cmd("stopinsert")
          end
          require("smart-splits")["move_cursor_" .. direction]()
        end
      end
      vim.keymap.set("n", "<C-h>", nav_with_stopinsert("left"), { desc = "Move to left split" })
      vim.keymap.set("n", "<C-j>", nav_with_stopinsert("down"), { desc = "Move to below split" })
      vim.keymap.set("n", "<C-k>", nav_with_stopinsert("up"), { desc = "Move to above split" })
      vim.keymap.set("n", "<C-l>", nav_with_stopinsert("right"), { desc = "Move to right split" })
      vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-h>", require("smart-splits").resize_left, { desc = "Resize left" })
      vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-j>", require("smart-splits").resize_down, { desc = "Resize down" })
      vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-k>", require("smart-splits").resize_up, { desc = "Resize up" })
      vim.keymap.set({ "n", "i", "t", "v" }, "<C-S-l>", require("smart-splits").resize_right, { desc = "Resize right" })
    end,
  },

  -- File explorer
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      win_options = {
        winbar = "%!v:lua.require('oil').get_current_dir()",
        signcolumn = "yes:2",
      },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["R"] = "actions.refresh",
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
    },
  },

  -- Git status icons in Oil
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
  },
}
