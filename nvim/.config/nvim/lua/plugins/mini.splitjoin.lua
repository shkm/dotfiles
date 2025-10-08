-- adds gS to toggle splitjoin
return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    require("mini.splitjoin").setup()
  end,
}
