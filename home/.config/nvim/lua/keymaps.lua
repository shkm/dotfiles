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

-- Terminal escape: use <M-j> instead (line 15) to avoid conflicts with apps that use Esc
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal reflow - force resize to trigger reflow
local function terminal_reflow()
  local win = vim.api.nvim_get_current_win()
  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_height(win, height - 1)
  vim.api.nvim_win_set_height(win, height)
end
vim.keymap.set({ "n", "t" }, "<C-S-l>", terminal_reflow, { desc = "Reflow terminal" })

-- Toggle terminal (one per tab)
local function toggle_tab_terminal()
  local tab = vim.api.nvim_get_current_tabpage()
  local term_buf = vim.t[tab].terminal_buf

  -- Check if the terminal buffer is still valid
  if term_buf and not vim.api.nvim_buf_is_valid(term_buf) then
    vim.t[tab].terminal_buf = nil
    term_buf = nil
  end

  -- If terminal window is visible in this tab, close it
  if term_buf then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        vim.api.nvim_win_close(win, false)
        return
      end
    end
  end

  -- Open a split with the existing terminal buffer, or create a new one
  vim.cmd("botright split")
  vim.api.nvim_win_set_height(0, 15)
  if term_buf then
    vim.api.nvim_set_current_buf(term_buf)
  else
    vim.cmd("terminal")
    vim.t[tab].terminal_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t", "i" }, "<C-`>", toggle_tab_terminal, { noremap = true, silent = true, desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>ot", toggle_tab_terminal, { noremap = true, silent = true, desc = "Toggle terminal" })

-- Dashes (macOS-style shortcuts don't work in terminal)
vim.keymap.set("i", "<M-S-->", "—", { desc = "Em dash" })
vim.keymap.set("i", "<M-->", "–", { desc = "En dash" })

-- Diagnostic quickfix
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix" })

-- Custom commands
vim.api.nvim_create_user_command("PrettyJson", "%!python -m json.tool", {})
vim.api.nvim_create_user_command("PrettyHtml", "%!tidy -q -i --show-errors 0 --raw", {})
vim.api.nvim_create_user_command("PrettyXml", "%!tidy -q -i -xml --show-errors 0 --raw", {})
