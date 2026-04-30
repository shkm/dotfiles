return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
  },
  keys = {
    { "<leader>s", nil, desc = "Spec/Test" },
    { "<leader>ss", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>sf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
    { "<leader>sl", function() require("neotest").run.run_last() end, desc = "Run last test" },
    { "<leader>so", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    { "<leader>su", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
    { "<leader>sx", function() require("neotest").run.stop() end, desc = "Stop test" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rspec"),
      },
    })
  end,
}
