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

-- Neovide
if vim.g.neovide then
  vim.g.neovide_padding_top = 15
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.o.guifont = "0xProto Nerd Font Mono:h14"
  vim.g.neovide_opacity = 0.9
  vim.g.transparency = 0.85
  -- vim.g.neovide_background_color = "#1e1e2e" .. string.format("%x", math.floor(255 * vim.g.transparency))
  vim.g.neovide_window_blurred = true

  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode
  vim.keymap.set("t", "<D-v>", '<C-\\><C-n>"+Pi') -- Paste terminal mode
end
