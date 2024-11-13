-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

--
-- Various
--

vim.api.nvim_set_keymap("n", "<Leader><Tab>", "<C-^>", { noremap = true, silent = true })

-- ; → :
vim.api.nvim_set_keymap("n", ":", ";", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", ";", ":", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ":", ";", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ";", ":", { noremap = true, silent = true })

-- Remap 0 to ^ (first char in line)
vim.api.nvim_set_keymap("n", "0", "^", { noremap = true, silent = true })

--#region
vim.api.nvim_set_keymap("n", "<Leader>gb", ":Gitsigns blame<CR>", { noremap = true, silent = true })

--
-- Files
--
vim.api.nvim_set_keymap(
  "n",
  "<Leader>fa",
  ":Telescope telescope-alternate alternate_file<CR>",
  { noremap = true, silent = true }
)
