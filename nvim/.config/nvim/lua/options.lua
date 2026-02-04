-- Neovim options

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Disable netrw (use oil instead)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.exrc = true -- Load .nvim.lua from project directories

vim.filetype.add({
  pattern = {
    [".*%.yaml%..*"] = "yaml",
  },
})

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Neovide
if vim.g.neovide then
  vim.g.neovide_padding_top = 15
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 0.98
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency or 0.95))
  end
  vim.g.neovide_background_color = "#1e1e2e" .. alpha()
  vim.g.neovide_window_blurred = true
end
