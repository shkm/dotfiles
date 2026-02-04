-- Keymaps (non-plugin)

-- Swap ; and :
vim.keymap.set({ "n", "v" }, ":", ";", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, ";", ":", { noremap = true, silent = true })

-- 0 goes to first non-blank character
vim.keymap.set("n", "0", "^", { noremap = true, silent = true })

-- Alternate file
vim.keymap.set("n", "<Leader><Tab>", "<C-^>", { noremap = true, silent = true, desc = "Alternate file" })

-- Exit insert/terminal mode with Alt+j
vim.keymap.set("i", "<M-j>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "<M-j>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Tab navigation
vim.keymap.set(
  { "n", "i", "t", "v" },
  "<M-h>",
  "<cmd>tabprev<CR>",
  { noremap = true, silent = true, desc = "Previous tab" }
)
vim.keymap.set(
  { "n", "i", "t", "v" },
  "<M-l>",
  "<cmd>tabnext<CR>",
  { noremap = true, silent = true, desc = "Next tab" }
)

-- Terminal escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal reflow - force resize to trigger reflow
local function terminal_reflow()
  local win = vim.api.nvim_get_current_win()
  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_height(win, height - 1)
  vim.api.nvim_win_set_height(win, height)
end
vim.keymap.set({ "n", "t" }, "<C-S-l>", terminal_reflow, { desc = "Reflow terminal" })

-- Diagnostic quickfix
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix" })

-- Custom commands
vim.api.nvim_create_user_command("PrettyJson", "%!python -m json.tool", {})
vim.api.nvim_create_user_command("PrettyHtml", "%!tidy -q -i --show-errors 0 --raw", {})
vim.api.nvim_create_user_command("PrettyXml", "%!tidy -q -i -xml --show-errors 0 --raw", {})
