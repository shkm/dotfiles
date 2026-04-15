return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      treesitter.install({ "ruby" })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- Mini.nvim modules
  {
    "echasnovski/mini.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
    end,
  },

  -- Splitjoin-alike (treesj)
  {
    "Wansmer/treesj",
    keys = {
      {
        "gJ",
        function() require("treesj").join() end,
        desc = "Join code block",
      },
      {
        "gS",
        function() require("treesj").split() end,
        desc = "Split code block",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },

  -- Which-key for keybind hints
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { "<leader>a", group = "AI/Claude" },
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>n", group = "Notes" },
        { "<leader>t", group = "Toggle" },
        { "<leader>w", group = "Worktree" },
      },
    },
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Move function arguments
  {
    "AndrewRadev/sideways.vim",
    cmd = { "SidewaysLeft", "SidewaysRight" },
    keys = {
      { "H", ":SidewaysLeft<CR>", desc = "Move argument left" },
      { "L", ":SidewaysRight<CR>", desc = "Move argument right" },
    },
  },

  -- Emacs-style editing
  { "tpope/vim-rsi", event = "InsertEnter" },
}
