-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.api.nvim_create_user_command("PrettyJson", "%!python -m json.tool", {})
vim.api.nvim_create_user_command("PrettyHtml", "%!tidy -q -i --show-errors 0 --raw", {})
vim.api.nvim_create_user_command("PrettyXml", "%!tidy -q -i -xml --show-errors 0 --raw", {})

vim.g.neovide_padding_top = 15
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
