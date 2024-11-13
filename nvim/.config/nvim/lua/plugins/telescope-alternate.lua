return {
  "otavioschwanck/telescope-alternate",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope-alternate").setup({
      presets = { "rails", "rspec" }, -- Telescope pre-defined mapping presets
    })
    require("telescope").load_extension("telescope-alternate")
  end,
}
