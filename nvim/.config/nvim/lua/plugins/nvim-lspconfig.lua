return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    keys[#keys + 1] = { "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>" }
  end,
}
