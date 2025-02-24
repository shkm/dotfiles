return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Load existing key mappings
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- Add your custom key mapping
    keys[#keys + 1] = { "<C-]>", "<cmd>lua vim.lsp.buf.definition()<cr>" }

    -- Ensure existing options are preserved and merged
    opts = opts or {}
    opts.servers = opts.servers or {}
    opts.keymaps = keys

    -- Configure the ruby_lsp server
    opts.servers.rubocop = {
      mason = false,
    }

    return opts
  end,
}
