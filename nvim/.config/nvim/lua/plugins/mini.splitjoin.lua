-- adds gS to toggle splitjoin
return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.splitjoin").setup()
  end,
}
