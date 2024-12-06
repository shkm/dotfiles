-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.api.nvim_create_user_command("PrettyJson", "%!python -m json.tool", {})
vim.api.nvim_create_user_command("PrettyHtml", "%!tidy -q -i --show-errors 0 --raw", {})
vim.api.nvim_create_user_command("PrettyXml", "%!tidy -q -i -xml --show-errors 0 --raw", {})

-- Neovide
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
