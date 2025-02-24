return {
  "folke/snacks.nvim",
  keys = {
    {
      "-",
      function()
        Snacks.explorer.open()
      end,
      desc = "Toggle Snacks Explorer",
    },
  },
}
