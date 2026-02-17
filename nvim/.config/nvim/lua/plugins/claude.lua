return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function(_, opts)
    require("claude-code").setup(opts)

    -- Set up mode-dependent border color for claude float
    local function update_float_border()
      local win = vim.api.nvim_get_current_win()
      local ok, config = pcall(vim.api.nvim_win_get_config, win)
      if not ok or not config.relative or config.relative == "" then return end
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
      if not bufname:match("claude") then return end
      local mode = vim.api.nvim_get_mode().mode
      local hl = mode == "t" and "ClaudeBorderTerminal" or "ClaudeBorderNormal"
      vim.wo[win].winhighlight = "FloatBorder:" .. hl
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      callback = function(ev)
        vim.schedule(function()
          local name = vim.api.nvim_buf_get_name(ev.buf)
          if name:match("claude%-code") then
            vim.keymap.set("n", "q", "<cmd>ClaudeCode<cr>", { buffer = ev.buf, desc = "Hide Claude Code" })
            vim.api.nvim_create_autocmd("ModeChanged", {
              buffer = ev.buf,
              callback = update_float_border,
            })
            update_float_border()
          end
        end)
      end,
    })

    -- Border highlights matching catppuccin lualine mode colors
    local palette_ok, palettes = pcall(require, "catppuccin.palettes")
    if palette_ok then
      local c = palettes.get_palette("mocha")
      vim.api.nvim_set_hl(0, "ClaudeBorderNormal", { fg = c.blue })
      vim.api.nvim_set_hl(0, "ClaudeBorderTerminal", { fg = c.green })
    end
  end,
  opts = {
    window = {
      position = "float",
      float_opts = {
        width = 0.9,
        height = 0.9,
      },
      enter_insert = false,
      start_in_normal_mode = true,
    },
    keymaps = {
      toggle = {
        normal = "<C-'>",
        terminal = "<C-'>",
        variants = {},
      },
    },
  },
  keys = {
    { "<leader>a", nil, desc = "AI" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
    { "<leader>ar", "<cmd>ClaudeCodeResume<cr>", desc = "Resume conversation" },
    { "<C-'>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "Toggle Claude Code" },
  },
}
