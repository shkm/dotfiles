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
vim.o.showtabline = 1
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.undofile = true
vim.o.backupdir = vim.fn.stdpath("state") .. "/backup//"
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
vim.o.cmdheight = 0
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
