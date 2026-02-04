-- Neovim configuration

vim.loader.enable()

-- Load configuration modules
require("options")
require("keymaps")
require("autocmds")

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/plugins/
require("lazy").setup("plugins", {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "󰘳",
      config = "󱁤",
      event = "󰃭",
      ft = "󰉋",
      init = "󰒓",
      keys = "",
      plugin = "󰚥",
      runtime = "󰌢",
      require = "󰽥",
      source = "󰈮",
      start = "󰑣",
      task = "󰐃",
      lazy = "󰒲 ",
    },
  },
})
